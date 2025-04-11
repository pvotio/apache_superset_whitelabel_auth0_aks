import os
import requests
import time
from superset.security import SupersetSecurityManager
import logging

from custom_auth_oauth_view import CustomAuthOauthView


logger = logging.getLogger('auth0_login')


AUTH0_URL = os.environ.get("AUTH0_API_URL")
AUTH0_API_CLIENT_ID = os.environ.get("AUTH0_API_CLIENT_KEY")
AUTH0_API_CLIENT_SECRET = os.environ.get("AUTH0_API_CLIENT_SECRET")


def robust_request(*args, **kwargs):
    MAX_RETRIES = 3
    BACKOFF_FACTOR = 2
    retry = 0
    while retry < MAX_RETRIES:
        try:
            response = requests.request(*args, **kwargs)
            response.raise_for_status()
            return response
        
        except requests.exceptions.RequestException as e:
            retry += 1
            if retry == MAX_RETRIES:
                raise e
            else:
                sleep_time = BACKOFF_FACTOR ** retry
                time.sleep(sleep_time)


def get_auth0_token(domain, client_id, client_secret):
    headers = { 'content-type': "application/json" }

    payload = {
        'client_id': client_id,
        'client_secret': client_secret,
        'audience': domain + '/api/v2/',
        'grant_type': 'client_credentials'
    }

    response = robust_request('POST', domain + '/oauth/token', headers=headers, json=payload) 
    return response.json()['access_token']


def get_user_roles(domain, token, user_id):
    url = f"{domain}/api/v2/users/{user_id}/roles"
    headers = {"Authorization": f"Bearer {token}"}
    response = robust_request('get', url, headers=headers)
    response.raise_for_status()
    roles = [role["name"] for role in response.json()]
    return roles


class CustomSsoSecurityManager(SupersetSecurityManager):

    authoauthview = CustomAuthOauthView

    def __init__(self, appbuilder):
        super(CustomSsoSecurityManager, self).__init__(appbuilder)

    def oauth_user_info(self, provider, response=None):
        if provider == 'auth0':
            oauth_resp = self.appbuilder.sm.oauth_remotes[provider]
            res = oauth_resp.get('userinfo')

            if res.raw.status != 200:
                logger.error('Failed to obtain user info: %s', res.json())
                return
            
            me = res.json()
            logger.info(me)

            token = get_auth0_token(AUTH0_URL, AUTH0_API_CLIENT_ID, AUTH0_API_CLIENT_SECRET)
            roles = get_user_roles(AUTH0_URL, token, me['sub'])

            return {
                'username' : me['email'],
                'name' : me['name'],
                'email' : me['email'],
                'role_keys': roles if isinstance(roles, list) else []
            }
