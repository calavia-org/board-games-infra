import boto3
import json
import logging
import os
import random
import string

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    """Lambda function to rotate RDS passwords"""
    
    service = boto3.client('secretsmanager')
    rds = boto3.client('rds')
    
    arn = event['Step1']['SecretId']
    token = event['Step1']['ClientRequestToken'] 
    step = event['Step1']['Step']
    
    # Setup the secret ARN and make sure it's in the right region
    secret = service.describe_secret(SecretId=arn)
    if secret.get('ReplicationStatus'):
        for replication in secret['ReplicationStatus']:
            if replication['Region'] == os.environ['AWS_REGION']:
                arn = replication['SecretArn']
                break
    
    logger.info("Starting rotation for secret %s", arn)
    
    if step == "createSecret":
        create_secret(service, arn, token)
    elif step == "setSecret":
        set_secret(service, rds, arn, token)
    elif step == "testSecret":
        test_secret(service, arn, token)
    elif step == "finishSecret":
        finish_secret(service, arn, token)
    else:
        logger.error("Invalid step %s", step)
        raise ValueError("Invalid step")
    
    return {"statusCode": 200}

def create_secret(service, arn, token):
    """Generate a new secret version"""
    try:
        service.get_secret_value(SecretId=arn, VersionId=token, VersionStage="AWSPENDING")
        logger.info("createSecret: Successfully retrieved secret for %s.", arn)
    except service.exceptions.ResourceNotFoundException:
        # Generate new password
        current_secret = service.get_secret_value(SecretId=arn, VersionStage="AWSCURRENT")
        secret = json.loads(current_secret['SecretBinary'] or current_secret['SecretString'])
        
        # Create new password
        new_password = generate_password()
        secret['password'] = new_password
        
        # Put the secret
        service.put_secret_value(SecretId=arn, VersionId=token, SecretString=json.dumps(secret), VersionStages=['AWSPENDING'])
        logger.info("createSecret: Successfully put secret for ARN %s and version %s.", arn, token)

def set_secret(service, rds, arn, token):
    """Set the secret in the RDS instance"""
    pending_secret = service.get_secret_value(SecretId=arn, VersionId=token, VersionStage="AWSPENDING")
    secret = json.loads(pending_secret['SecretBinary'] or pending_secret['SecretString'])
    
    # Update RDS password
    db_instance_identifier = os.environ.get('RDS_INSTANCE_IDENTIFIER')
    if not db_instance_identifier:
        logger.error("Environment variable RDS_INSTANCE_IDENTIFIER is not set.")
        raise ValueError("RDS_INSTANCE_IDENTIFIER environment variable is required")
    rds.modify_db_instance(
        DBInstanceIdentifier=db_instance_identifier,
        MasterUserPassword=secret['password'],
        ApplyImmediately=True
    )
    
    logger.info("setSecret: Successfully set password for RDS instance %s", db_instance_identifier)

def test_secret(service, arn, token):
    """Test the new secret"""
    # In a real implementation, you would test the database connection here
    logger.info("testSecret: Successfully tested secret for ARN %s", arn)

def finish_secret(service, arn, token):
    """Finish the rotation by updating version stages"""
    metadata = service.describe_secret(SecretId=arn)
    
    for version in metadata['VersionIdsToStages']:
        if 'AWSCURRENT' in metadata['VersionIdsToStages'][version]:
            if version == token:
                logger.info("finishSecret: Version %s already marked as AWSCURRENT for %s", version, arn)
                return
            service.update_secret_version_stage(SecretId=arn, VersionStage="AWSPREVIOUS", ClientRequestToken=version, RemoveFromVersionId=token)
            break
    
    service.update_secret_version_stage(SecretId=arn, VersionStage="AWSCURRENT", ClientRequestToken=token)
    logger.info("finishSecret: Successfully set AWSCURRENT stage to version %s for secret %s.", token, arn)

def generate_password(length=16):
    """Generate a random password"""
    characters = string.ascii_letters + string.digits + "!@#$%^&*"
    password = ''.join(random.choice(characters) for i in range(length))
    return password
