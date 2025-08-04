import json
import boto3
import logging
import redis
import os
import time
from botocore.exceptions import ClientError

# Configure logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    """
    Lambda function to rotate Redis auth tokens in AWS Secrets Manager
    """
    service = boto3.client('secretsmanager', region_name='${region}')
    elasticache = boto3.client('elasticache', region_name='${region}')

    # Extract parameters from event
    secret_arn = event['SecretId']
    token = event['ClientRequestToken']
    step = event['Step']

    logger.info(f"Starting Redis rotation for secret: {secret_arn}, step: {step}")

    try:
        if step == 'createSecret':
            create_secret(service, secret_arn, token)
        elif step == 'setSecret':
            set_secret(service, elasticache, secret_arn, token)
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
    Create a new secret version with a new auth token
    """
    try:
        # Get current secret
        current_secret = get_secret_dict(service, secret_arn, "AWSCURRENT")

        # Generate new auth token
        new_auth_token = generate_auth_token()

        # Create new secret version
        new_secret = current_secret.copy()
        new_secret['auth_token'] = new_auth_token

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

def set_secret(service, elasticache, secret_arn, token):
    """
    Set the new auth token in ElastiCache Redis
    """
    try:
        # Get both current and pending secrets
        current_secret = get_secret_dict(service, secret_arn, "AWSCURRENT")
        pending_secret = get_secret_dict(service, secret_arn, "AWSPENDING", token)

        # Extract replication group ID from host
        host = current_secret['host']
        replication_group_id = extract_replication_group_id(host)

        if not replication_group_id:
            raise Exception(f"Could not extract replication group ID from host: {host}")

        # Update ElastiCache replication group with new auth token
        response = elasticache.modify_replication_group(
            ReplicationGroupId=replication_group_id,
            AuthToken=pending_secret['auth_token'],
            AuthTokenUpdateStrategy='ROTATE',
            ApplyImmediately=True
        )

        logger.info(f"Successfully initiated auth token rotation for {replication_group_id}")

        # Wait for the rotation to complete
        wait_for_rotation_completion(elasticache, replication_group_id)

    except Exception as e:
        logger.error(f"Error setting secret in ElastiCache: {str(e)}")
        raise e

def test_secret(service, secret_arn, token):
    """
    Test the new auth token by connecting to Redis
    """
    try:
        # Get pending secret
        pending_secret = get_secret_dict(service, secret_arn, "AWSPENDING", token)

        # Test connection with new auth token
        r = redis.Redis(
            host=pending_secret['host'],
            port=pending_secret['port'],
            password=pending_secret['auth_token'],
            socket_connect_timeout=5,
            socket_timeout=5,
            retry_on_timeout=True
        )

        # Simple test command
        result = r.ping()

        if result:
            logger.info("Successfully tested new auth token")
        else:
            raise Exception("Ping command failed")

    except Exception as e:
        logger.error(f"Error testing secret: {str(e)}")
        raise e

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

def extract_replication_group_id(host):
    """
    Extract replication group ID from ElastiCache endpoint
    """
    try:
        # ElastiCache endpoints typically follow pattern:
        # replication-group-id.cache.amazonaws.com
        if '.cache.amazonaws.com' in host:
            return host.split('.')[0]
        return None

    except Exception as e:
        logger.error(f"Error extracting replication group ID: {str(e)}")
        return None

def wait_for_rotation_completion(elasticache, replication_group_id, max_wait=300):
    """
    Wait for auth token rotation to complete
    """
    try:
        start_time = time.time()

        while time.time() - start_time < max_wait:
            response = elasticache.describe_replication_groups(
                ReplicationGroupId=replication_group_id
            )

            status = response['ReplicationGroups'][0]['Status']

            if status == 'available':
                logger.info(f"Auth token rotation completed for {replication_group_id}")
                return
            elif status == 'modifying':
                logger.info(f"Auth token rotation in progress for {replication_group_id}")
                time.sleep(30)
            else:
                raise Exception(f"Unexpected status during rotation: {status}")

        raise Exception(f"Timeout waiting for rotation completion after {max_wait} seconds")

    except Exception as e:
        logger.error(f"Error waiting for rotation completion: {str(e)}")
        raise e

def generate_auth_token(length=64):
    """
    Generate a secure random auth token
    """
    import secrets
    import string

    # Use alphanumeric characters for auth token
    chars = string.ascii_letters + string.digits
    return ''.join(secrets.choice(chars) for _ in range(length))
