import json
import boto3
import logging
import base64
import os
import time
from botocore.exceptions import ClientError
from kubernetes import client, config
from kubernetes.client.rest import ApiException

# Configure logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    """
    Lambda function to rotate Kubernetes Service Account tokens in AWS Secrets Manager
    """
    service = boto3.client('secretsmanager', region_name='${region}')
    eks = boto3.client('eks', region_name='${region}')

    # Extract parameters from event
    secret_arn = event['SecretId']
    token = event['ClientRequestToken']
    step = event['Step']

    logger.info(f"Starting Service Account token rotation for secret: {secret_arn}, step: {step}")

    try:
        if step == 'createSecret':
            create_secret(service, secret_arn, token)
        elif step == 'setSecret':
            set_secret(service, eks, secret_arn, token)
        elif step == 'testSecret':
            test_secret(service, eks, secret_arn, token)
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
    Create a new secret version with updated service account information
    """
    try:
        # Get current secret
        current_secret = get_secret_dict(service, secret_arn, "AWSCURRENT")

        # Create new secret version (token will be updated in setSecret step)
        new_secret = current_secret.copy()
        new_secret['rotation_timestamp'] = int(time.time())
        new_secret['rotation_token'] = token

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

def set_secret(service, eks, secret_arn, token):
    """
    Create new service account token in Kubernetes
    """
    try:
        # Get current secret to extract service account info
        current_secret = get_secret_dict(service, secret_arn, "AWSCURRENT")
        pending_secret = get_secret_dict(service, secret_arn, "AWSPENDING", token)

        # Extract service account name from secret name
        sa_name = extract_service_account_name(secret_arn)
        namespace = current_secret.get('namespace', get_namespace_for_service(sa_name))

        # Configure Kubernetes client
        k8s_client = configure_k8s_client(eks, os.environ['EKS_CLUSTER_NAME'])

        # Create new service account token
        new_token = create_service_account_token(k8s_client, sa_name, namespace)

        # Update pending secret with new token
        pending_secret['token'] = new_token
        pending_secret['namespace'] = namespace
        pending_secret['service_account'] = sa_name
        pending_secret['cluster_name'] = os.environ['EKS_CLUSTER_NAME']

        # Save updated secret
        service.put_secret_value(
            SecretId=secret_arn,
            VersionId=token,
            SecretString=json.dumps(pending_secret),
            VersionStage="AWSPENDING"
        )

        logger.info(f"Successfully created new token for service account: {sa_name}")

    except Exception as e:
        logger.error(f"Error setting secret: {str(e)}")
        raise e

def test_secret(service, eks, secret_arn, token):
    """
    Test the new service account token
    """
    try:
        # Get pending secret
        pending_secret = get_secret_dict(service, secret_arn, "AWSPENDING", token)

        # Configure Kubernetes client with new token
        k8s_client = configure_k8s_client_with_token(
            eks,
            os.environ['EKS_CLUSTER_NAME'],
            pending_secret['token']
        )

        # Test the token by making a simple API call
        v1 = client.CoreV1Api(k8s_client)

        # Try to list pods in the service account's namespace
        namespace = pending_secret.get('namespace', 'default')
        try:
            v1.list_namespaced_pod(namespace=namespace, limit=1)
            logger.info("Successfully tested new service account token")
        except ApiException as e:
            if e.status == 403:
                # Token works but might not have pod list permissions - that's OK
                logger.info("Token authenticated but has limited permissions (expected)")
            else:
                raise e

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

def extract_service_account_name(secret_arn):
    """
    Extract service account name from secret ARN
    """
    try:
        # Extract from secret name pattern: cluster-service-sa-token
        secret_name = secret_arn.split(':')[-1]

        if 'prometheus' in secret_name:
            return 'prometheus'
        elif 'external-dns' in secret_name:
            return 'external-dns'
        elif 'cert-manager' in secret_name:
            return 'cert-manager'
        elif 'grafana' in secret_name:
            return 'grafana'
        else:
            # Fallback: extract from secret name
            parts = secret_name.split('-')
            return '-'.join(parts[1:-2])  # Remove cluster prefix and sa-token suffix

    except Exception as e:
        logger.error(f"Error extracting service account name: {str(e)}")
        raise e

def get_namespace_for_service(service_name):
    """
    Get appropriate namespace for service
    """
    namespace_map = {
        'prometheus': 'monitoring',
        'grafana': 'monitoring',
        'external-dns': 'kube-system',
        'cert-manager': 'cert-manager'
    }

    return namespace_map.get(service_name, 'default')

def configure_k8s_client(eks, cluster_name):
    """
    Configure Kubernetes client using EKS cluster info
    """
    try:
        # Get cluster info
        cluster_info = eks.describe_cluster(name=cluster_name)
        cluster_endpoint = cluster_info['cluster']['endpoint']
        cluster_ca = cluster_info['cluster']['certificateAuthority']['data']

        # Get token using AWS CLI equivalent
        sts = boto3.client('sts')
        token = get_bearer_token(cluster_name, sts)

        # Configure client
        configuration = client.Configuration()
        configuration.host = cluster_endpoint
        configuration.ssl_ca_cert_data = base64.b64decode(cluster_ca)
        configuration.api_key = {"authorization": "Bearer " + token}

        return client.ApiClient(configuration)

    except Exception as e:
        logger.error(f"Error configuring Kubernetes client: {str(e)}")
        raise e

def configure_k8s_client_with_token(eks, cluster_name, sa_token):
    """
    Configure Kubernetes client using service account token
    """
    try:
        # Get cluster info
        cluster_info = eks.describe_cluster(name=cluster_name)
        cluster_endpoint = cluster_info['cluster']['endpoint']
        cluster_ca = cluster_info['cluster']['certificateAuthority']['data']

        # Configure client with SA token
        configuration = client.Configuration()
        configuration.host = cluster_endpoint
        configuration.ssl_ca_cert_data = base64.b64decode(cluster_ca)
        configuration.api_key = {"authorization": "Bearer " + sa_token}

        return client.ApiClient(configuration)

    except Exception as e:
        logger.error(f"Error configuring Kubernetes client with token: {str(e)}")
        raise e

def get_bearer_token(cluster_name, sts):
    """
    Generate bearer token for EKS authentication using the official AWS method.
    """
    try:
        # Official AWS EKS token generation method
        import urllib.parse
        # The audience is always the cluster name for EKS
        service_id = "sts"
        # Presigned URL expires in 60 seconds
        presigned_url = sts.generate_presigned_url(
            'get_caller_identity',
            Params={},
            ExpiresIn=60,
            HttpMethod='GET'
        )
        # The token must be in the format: k8s-aws-v1.<base64url-encoded-presigned-url-without-padding>
        encoded_url = base64.urlsafe_b64encode(presigned_url.encode('utf-8')).decode('utf-8').rstrip("=")
        token = f"k8s-aws-v1.{encoded_url}"
        return token
    except Exception as e:
        logger.error(f"Error generating bearer token: {str(e)}")
        raise e

def create_service_account_token(k8s_client, sa_name, namespace):
    """
    Create a new service account token
    """
    try:
        v1 = client.CoreV1Api(k8s_client)

        # Create token request
        token_request = client.V1TokenRequest(
            spec=client.V1TokenRequestSpec(
                audiences=["api"],
                expiration_seconds=7776000  # 90 days
            )
        )

        # Create the token
        response = v1.create_namespaced_service_account_token(
            name=sa_name,
            namespace=namespace,
            body=token_request
        )

        return response.status.token

    except Exception as e:
        logger.error(f"Error creating service account token: {str(e)}")
        raise e
