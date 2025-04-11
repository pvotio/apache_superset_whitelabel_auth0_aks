import os
import logging
from flask import redirect, request
from flask_appbuilder.security.decorators import has_access
from superset.views.base import BaseSupersetView
from flask_appbuilder import expose

from azure.identity import DefaultAzureCredential
from azure.storage.blob import generate_blob_sas, BlobSasPermissions, BlobServiceClient, UserDelegationKey
from datetime import datetime, timedelta, timezone, UTC

logger = logging.getLogger(__name__)
BLOB_DOWNLOAD_LINK_FQDN = os.environ.get("BLOB_DOWNLOAD_LINK_FQDN")

class BlobKeyGenerator:
    def __init__(self):
        self.key : UserDelegationKey = None
        self.storage_account_name = os.environ.get("BLOB_STORAGE_ACCOUNT_NAME")
        self.container_name = os.environ.get("BLOB_CONTAINER_NAME")
        logger.info(f"BlobKeyGenerator.init. storage_account_name: {self.storage_account_name}, container_name: {self.container_name}")

    def get_key(self) -> UserDelegationKey:
        if self.key is not None:
            exp_date = datetime.strptime(self.key.signed_expiry, '%Y-%m-%dT%H:%M:%SZ').replace(tzinfo=timezone.utc)
            if exp_date > datetime.now(UTC) + timedelta(hours=5):
                logger.info(f"get_key: return cached key, valid until: {self.key.signed_expiry}")
                return self.key

        try:
            logger.info(f"Request new user delegation key. storage_account_name: {self.storage_account_name}, container_name: {self.container_name}")
            blob_service_client = BlobServiceClient(account_url=f"https://{self.storage_account_name}.blob.core.windows.net", credential=DefaultAzureCredential())
            logger.info("blob_service_client requested")
            delegation_key_start_time = datetime.now(timezone.utc)
            delegation_key_expiry_time = delegation_key_start_time + timedelta(days=1)
            self.key = blob_service_client.get_user_delegation_key(
                key_start_time=delegation_key_start_time,
                key_expiry_time=delegation_key_expiry_time
            )
            logger.info(f"get_key: return newly created key, valid until: {self.key.signed_expiry}")
            return self.key

        except Exception as e:
            logger.error("Failed to request new user delegation key:")
            logger.error(str(e))
            raise

blob_key_generator = BlobKeyGenerator()

def generate_document_url(file_name):
    try:
        sas_token = generate_blob_sas(
            account_name=blob_key_generator.storage_account_name,
            container_name=blob_key_generator.container_name,
            user_delegation_key=blob_key_generator.get_key(),
            blob_name=file_name,
            permission=BlobSasPermissions(read=True),
            expiry=datetime.now(UTC) + timedelta(minutes=5),
        )
        return f"https://{BLOB_DOWNLOAD_LINK_FQDN}/{file_name}?{sas_token}"

    except Exception as e:
        logger.error("Failed to generate SAS token:")
        logger.error(str(e))
        raise


class BlobStorageLinkGeneratorView(BaseSupersetView):

    route_base = "/reports"

    @has_access
    @expose("/blob")
    def redirect_to_reporting(self):
        data = dict(request.args)
        file_arg = data["file"]
        logger.info(f"redirect_to_reporting: {file_arg}")
        redirect_url = generate_document_url(file_arg)
        return redirect(redirect_url, code=302)
