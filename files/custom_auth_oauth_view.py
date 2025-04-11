import os
import re
import jwt
import logging
from urllib.parse import urlparse

from authlib.integrations.base_client.errors import MismatchingStateError

from flask_login import login_user, logout_user
from flask_appbuilder._compat import as_unicode
from flask_appbuilder.security.views import expose
from flask import flash, g, redirect, request, url_for
from flask_appbuilder.security.views import AuthOAuthView


logger = logging.getLogger('auth0_login')


class CustomAuthOauthView(AuthOAuthView):

    login_template = "appbuilder/general/security/login_oauth_customized.html"
    logout_template = "appbuilder/general/security/logout_oauth_customized.html"

    @expose("/logout/")
    def logout(self):
        AUTH0_URL = os.environ.get("AUTH0_URL")
        CLIENT_ID = os.environ.get("AUTH0_CLIENT_KEY")
        logout_user()
        logout_url = f"{AUTH0_URL}/v2/logout?client_id={CLIENT_ID}" 
        return redirect(logout_url)
        # return self.render_template(
        #         self.logout_template,
        #         appbuilder=self.appbuilder,
        #     )
    
    @expose("/login/")
    @expose("/login/<provider>")
    @expose("/login/<provider>/<register>")
    def login(self, provider=None):
        logger.debug("Provider: {0}".format(provider))
        if g.user is not None and g.user.is_authenticated:
            logger.debug("Already authenticated {0}".format(g.user))
            return redirect(self.appbuilder.get_url_for_index)

        if provider is None:
            provider = 'auth0'
            # return redirect(url_for('CustomAuthOauthView.login', provider='auth0') + '?next=')
            # return self.render_template(
            #     self.login_template,
            #     providers=self.appbuilder.sm.oauth_providers,
            #     title=self.title,
            #     appbuilder=self.appbuilder,
            # )

        logger.debug("Going to call authorize for: {0}".format(provider))
        state = jwt.encode(
            request.args.to_dict(flat=False),
            self.appbuilder.app.config["SECRET_KEY"],
            algorithm="HS256",
        )
        try:
            if provider == "twitter":
                return self.appbuilder.sm.oauth_remotes[provider].authorize_redirect(
                    redirect_uri=url_for(
                        ".oauth_authorized",
                        provider=provider,
                        _external=True,
                        state=state,
                    )
                )
            else:
                return self.appbuilder.sm.oauth_remotes[provider].authorize_redirect(
                    redirect_uri=url_for(
                        ".oauth_authorized", provider=provider, _external=True
                    ),
                    state=state.decode("ascii") if isinstance(state, bytes) else state,
                )
        except Exception as e:
            logger.error("Error on OAuth authorize: {0}".format(e))
            flash(as_unicode(self.invalid_login_message), "warning")
            return redirect(self.appbuilder.get_url_for_index)
        
    @expose("/oauth-authorized/<provider>")
    def oauth_authorized(self, provider: str):
        logger.debug("Authorized init")

        if provider not in self.appbuilder.sm.oauth_remotes:
            flash(u"Provider not supported.", "warning")
            logger.warning("OAuth authorized got an unknown provider %s", provider)
            return redirect(self.appbuilder.get_url_for_login)

        try:
            resp = self.appbuilder.sm.oauth_remotes[provider].authorize_access_token()
        except MismatchingStateError:
            logger.debug("2008 MismatchingStateError {0}, redirecting to index.".format(g.user))
            return redirect(self.appbuilder.get_url_for_index)

        if resp is None:
            flash(u"You denied the request to sign in.", "warning")
            return redirect(self.appbuilder.get_url_for_login)
        logger.debug("OAUTH Authorized resp: {0}".format(resp))
        # Retrieves specific user info from the provider
        try:
            self.appbuilder.sm.set_oauth_session(provider, resp)
            userinfo = self.appbuilder.sm.oauth_user_info(provider, resp)
        except Exception as e:
            logger.error("Error returning OAuth user info: {0}".format(e))
            user = None
        else:
            logger.debug("User info retrieved from {0}: {1}".format(provider, userinfo))
            # User email is not whitelisted
            if provider in self.appbuilder.sm.oauth_whitelists:
                whitelist = self.appbuilder.sm.oauth_whitelists[provider]
                allow = False
                for email in whitelist:
                    if "email" in userinfo and re.search(email, userinfo["email"]):
                        allow = True
                        break
                if not allow:
                    flash(u"You are not authorized.", "warning")
                    return redirect(self.appbuilder.get_url_for_login)
            else:
                logger.debug("No whitelist for OAuth provider")
            user = self.appbuilder.sm.auth_user_oauth(userinfo)

        if user is None:
            flash(as_unicode(self.invalid_login_message), "warning")
            return redirect(self.appbuilder.get_url_for_login)
        else:
            login_user(user)
            try:
                state = jwt.decode(
                    request.args["state"],
                    self.appbuilder.app.config["SECRET_KEY"],
                    algorithms=["HS256"],
                )
            except jwt.InvalidTokenError:
                raise Exception("State signature is not valid!")

            next_url = self.appbuilder.get_url_for_index
            # Check if there is a next url on state
            if "next" in state and len(state["next"]) > 0:
                parsed_uri = urlparse(state["next"][0])
                if parsed_uri.netloc != request.host:
                    logger.warning("Got an invalid next URL: %s", parsed_uri.netloc)
                else:
                    next_url = state["next"][0]

            next_url = '/dashboard/list'
            return redirect(next_url)