import functools

from django.shortcuts import redirect

from .handlers import AzureSigninHandler


def azure_signin_required(func):
    @functools.wraps(func)
    def _wrapper(request, *args, **kwargs):

        # If the token is valid (or a new valid one can be generated)
        if AzureSigninHandler(request).get_token_from_cache():
            # If the user is authenticated
            if request.user.is_authenticated:
                return func(request, *args, **kwargs)
        return redirect("azure_signin:login")

    return _wrapper
