import json
import boto3
import logging
import psycopg2
import os
from botocore.exceptions import ClientError

# Configure logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    """
    Lambda function to rotate PostgreSQL credentials in AWS Secrets Manager
    """
    service = boto3.client('secretsmanager', region_name='${region}')

    # Extract parameters from event
    secret_arn = event['SecretId']
    token = event['ClientRequestToken']
    step = event['Step']

    logger.info(f"Starting PostgreSQL rotation for secret: {secret_arn}, step: {step}")

    try:
        if step == 'createSecret':
            create_secret(service, secret_arn, token)
        elif step == 'setSecret':
            set_secret(service, secret_arn, token)
        elif step == 'testSecret':
            test_secret(service, secret_arn, token)
        elif step == 'finishSecret':
            finish_secret(service, secret_arn, token)
        else:
            logger.error(f"Invalid step parameter: {step}")
            raise ValueError(f"Invalid step parameter: {step}")

        logger.info(f"Successfully completed step: {step}")
        return {'statusCode': 200}

    except Exception as e:
        logger.error(f"Error in step {step}: {str(e)}")
        raise e

def create_secret(service, secret_arn, token):
    """
    Create a new secret version with a new password
    """
    try:
        # Get current secret
        current_secret = get_secret_dict(service, secret_arn, "AWSCURRENT")

        # Generate new password
        new_password = generate_password()

        # Create new secret version
        new_secret = current_secret.copy()
        new_secret['password'] = new_password

        # Put the new secret
        service.put_secret_value(
            SecretId=secret_arn,
            VersionId=token,
            SecretString=json.dumps(new_secret),
            VersionStage="AWSPENDING"
        )

        logger.info("Successfully created new secret version")

    except ClientError as e:
        if e.response['Error']['Code'] == 'ResourceExistsException':
            logger.info("createSecret: Secret version already exists")
        else:
            raise e

def set_secret(service, secret_arn, token):
    """
    Set the new password in the PostgreSQL database
    """
    try:
        # Get both current and pending secrets
        current_secret = get_secret_dict(service, secret_arn, "AWSCURRENT")
        pending_secret = get_secret_dict(service, secret_arn, "AWSPENDING", token)

        # Connect to PostgreSQL using current credentials
        connection = psycopg2.connect(
            host=current_secret['host'],
            port=current_secret['port'],
            database=current_secret['dbname'],
            user=current_secret['username'],
            password=current_secret['password']
        )

        with connection.cursor() as cursor:
            # Check if this is master user or application user
            username = pending_secret['username']
            new_password = pending_secret['password']

            if 'app_user' in username:
                # For application users, create/update user with limited privileges
                query = sql.SQL("""
                    DO $$
                    BEGIN
                        IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = {username}) THEN
                            CREATE USER {username_ident} WITH PASSWORD {new_password};
                            GRANT CONNECT ON DATABASE {dbname_ident} TO {username_ident};
                            GRANT USAGE ON SCHEMA public TO {username_ident};
                            GRANT CREATE ON SCHEMA public TO {username_ident};
                        ELSE
                            ALTER USER {username_ident} WITH PASSWORD {new_password};
                        END IF;
                    END
                    $$;
                """).format(
                    username=sql.Literal(username),
                    username_ident=sql.Identifier(username),
                    new_password=sql.Literal(new_password),
                    dbname_ident=sql.Identifier(current_secret['dbname'])
                )
                cursor.execute(query)
            else:
                # For master user, just change password
                query = sql.SQL('ALTER USER {username} WITH PASSWORD {new_password}').format(
                    username=sql.Identifier(username),
                    new_password=sql.Literal(new_password)
                )
                cursor.execute(query)

            connection.commit()
            logger.info(f"Successfully updated password for user: {username}")

    except Exception as e:
        logger.error(f"Error setting secret in database: {str(e)}")
        raise e
    finally:
        if 'connection' in locals():
            connection.close()

def test_secret(service, secret_arn, token):
    """
    Test the new credentials by connecting to PostgreSQL
    """
    try:
        # Get pending secret
        pending_secret = get_secret_dict(service, secret_arn, "AWSPENDING", token)

        # Test connection with new credentials
        connection = psycopg2.connect(
            host=pending_secret['host'],
            port=pending_secret['port'],
            database=pending_secret['dbname'],
            user=pending_secret['username'],
            password=pending_secret['password']
        )

        # Simple test query
        with connection.cursor() as cursor:
            cursor.execute("SELECT 1")
            result = cursor.fetchone()

        if result[0] == 1:
            logger.info("Successfully tested new credentials")
        else:
            raise Exception("Test query returned unexpected result")

    except Exception as e:
        logger.error(f"Error testing secret: {str(e)}")
        raise e
    finally:
        if 'connection' in locals():
            connection.close()

def finish_secret(service, secret_arn, token):
    """
    Finish the rotation by updating version stages
    """
    try:
        # Move the AWSCURRENT stage to the new version
        service.update_secret_version_stage(
            SecretId=secret_arn,
            VersionStage="AWSCURRENT",
            ClientRequestToken=token,
            RemoveFromVersionId=get_secret_version_id(service, secret_arn, "AWSCURRENT")
        )

        logger.info("Successfully finished secret rotation")

    except Exception as e:
        logger.error(f"Error finishing secret rotation: {str(e)}")
        raise e

def get_secret_dict(service, secret_arn, stage, token=None):
    """
    Get secret as dictionary
    """
    try:
        kwargs = {'SecretId': secret_arn, 'VersionStage': stage}
        if token:
            kwargs['VersionId'] = token

        response = service.get_secret_value(**kwargs)
        return json.loads(response['SecretString'])

    except Exception as e:
        logger.error(f"Error getting secret: {str(e)}")
        raise e

def get_secret_version_id(service, secret_arn, stage):
    """
    Get version ID for a specific stage
    """
    try:
        response = service.describe_secret(SecretId=secret_arn)
        for version_id, version_info in response['VersionIdsToStages'].items():
            if stage in version_info:
                return version_id
        return None

    except Exception as e:
        logger.error(f"Error getting secret version ID: {str(e)}")
        raise e

def generate_password(length=32):
    """
    Generate a secure random password
    """
    import secrets
    import string

    # Define character sets
    lowercase = string.ascii_lowercase
    uppercase = string.ascii_uppercase
    digits = string.digits
    special = "!@#$%^&*"

    # Ensure at least one character from each set
    password = [
        secrets.choice(lowercase),
        secrets.choice(uppercase),
        secrets.choice(digits),
        secrets.choice(special)
    ]

    # Fill the rest randomly
    all_chars = lowercase + uppercase + digits + special
    for _ in range(length - 4):
        password.append(secrets.choice(all_chars))

    # Shuffle the password
    secrets.SystemRandom().shuffle(password)

    return ''.join(password)
