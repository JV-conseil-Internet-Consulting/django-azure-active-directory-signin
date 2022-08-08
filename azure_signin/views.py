import logging

from django.conf import settings
from django.contrib.auth import authenticate, login, logout
from django.http import HttpResponseForbidden, HttpResponseRedirect

from .handlers import AzureSigninHandler

logger = logging.getLogger(__name__)


def azure_signin_login(request):
    return HttpResponseRedirect(AzureSigninHandler(request).get_auth_uri())


def azure_signin_logout(request):
    logout(request)
    return HttpResponseRedirect(AzureSigninHandler(request).get_logout_uri())


def azure_signin_callback(request):
    "azure_signin_callback"
    output = HttpResponseForbidden("Invalid Authentication Token.")
    try:
        token = AzureSigninHandler(request).get_token_from_flow()
        user = authenticate(request, token=token)
        if user:
            login(request, user)
            output = HttpResponseRedirect(settings.LOGIN_REDIRECT_URL)
    except Exception as e:
        logger.exception(e)
    # logger.debug("_azure_signin_callback: %s", output)
    return output


def azure_signin_redirect(request):
    "azure_signin_redirect to handle Django success/error messages"
    output = HttpResponseRedirect(settings.LOGIN_REDIRECT_URL)
    try:
        token = AzureSigninHandler(request).get_token_from_flow()
        user = authenticate(request, token=token)
        if user:
            login(request, user)
    except Exception as e:
        logger.exception(e)
    # logger.debug("azure_signin_callback: %s", output)
    return output
