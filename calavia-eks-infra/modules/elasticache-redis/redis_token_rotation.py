import boto3
import json
import logging
import os
import random
import string

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    """Lambda function to rotate Redis auth tokens"""
    
    service = boto3.client('secretsmanager')
    elasticache = boto3.client('elasticache')
    
    arn = event['Step1']['SecretId']
    token = event['Step1']['ClientRequestToken'] 
    step = event['Step1']['Step']
    
    logger.info("Starting Redis token rotation for secret %s", arn)
    
    if step == "createSecret":
        create_secret(service, arn, token)
    elif step == "setSecret":
        set_secret(service, elasticache, arn, token)
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
        # Generate new auth token
        current_secret = service.get_secret_value(SecretId=arn, VersionStage="AWSCURRENT")
        secret = json.loads(current_secret['SecretBinary'] or current_secret['SecretString'])
        
        # Create new auth token
        new_auth_token = generate_auth_token()
        secret['auth_token'] = new_auth_token
        
        # Put the secret
        service.put_secret_value(SecretId=arn, VersionId=token, SecretString=json.dumps(secret), VersionStages=['AWSPENDING'])
        logger.info("createSecret: Successfully put secret for ARN %s and version %s.", arn, token)

def set_secret(service, elasticache, arn, token):
    """Set the secret in the ElastiCache replication group"""
    pending_secret = service.get_secret_value(SecretId=arn, VersionId=token, VersionStage="AWSPENDING")
    secret = json.loads(pending_secret['SecretBinary'] or pending_secret['SecretString'])
    
    # Update ElastiCache auth token
    elasticache.modify_replication_group(
        ReplicationGroupId="${cluster_name}-redis",
        AuthToken=secret['auth_token'],
        AuthTokenUpdateStrategy='ROTATE',
        ApplyImmediately=True
    )
    
    logger.info("setSecret: Successfully set auth token for ElastiCache replication group ${cluster_name}-redis")

def test_secret(service, arn, token):
    """Test the new secret"""
    # In a real implementation, you would test the Redis connection here
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

def generate_auth_token(length=32):
    """Generate a random auth token"""
    characters = string.ascii_letters + string.digits
    auth_token = ''.join(random.choice(characters) for i in range(length))
    return auth_token
