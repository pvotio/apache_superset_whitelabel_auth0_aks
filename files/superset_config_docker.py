from datetime import timedelta
import os
import string
import random

from flask_appbuilder.security.manager import AUTH_OAUTH
from custom_sso_security_manager import CustomSsoSecurityManager

CUSTOM_SECURITY_MANAGER = CustomSsoSecurityManager

AUTH_TYPE = AUTH_OAUTH
AUTH_USER_REGISTRATION = True
AUTH_ROLES_SYNC_AT_LOGIN = True

AUTH0_URL = os.environ.get("AUTH0_URL") 
AUTH0_CLIENT_KEY = os.environ.get("AUTH0_CLIENT_KEY")
AUTH0_CLIENT_SECRET = os.environ.get("AUTH0_CLIENT_SECRET")

nonce = ''.join(random.choices(string.ascii_uppercase + string.digits + string.ascii_lowercase, k = 30))

OAUTH_PROVIDERS = [
  {   'name':'auth0',
      'token_key':'access_token',
      'icon':'fa-circle-o',
      'remote_app': {
          'api_base_url': AUTH0_URL,
          'client_id': AUTH0_CLIENT_KEY,  
          'client_secret': AUTH0_CLIENT_SECRET, 
          'server_metadata_url': os.path.join(AUTH0_URL, '.well-known/openid-configuration'),
          'client_kwargs': {
              'scope': 'openid profile email groups'
          },
         'nonce': nonce,
      }
  }
]

AUTH_ROLES_MAPPING = {
    "superset_role_abc": ["Role_abc"],
    "superset_role_xyz": ["Role_xyz"],
}


APP_NAME = "XXXXX"
FEATURE_FLAGS = {
    'ENABLE_TEMPLATE_PROCESSING': True,
    'DASHBOARD_RBAC': True,
    'HORIZONTAL_FILTER_BAR': True,
}


HTML_SANITIZATION = False

TALISMAN_ENABLED = False

PERMANENT_SESSION_LIFETIME = timedelta(minutes=45)
