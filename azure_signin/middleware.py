from django.shortcuts import redirect
from django.urls import reverse

from .configuration import AzureSigninConfig
from .handlers import AzureSigninHandler


class AzureSigninMiddleware:
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        public_urls = [reverse(view_name) for view_name in AzureSigninConfig.PUBLIC_URLS]

        if request.path_info in public_urls:
            return self.get_response(request)

        if AzureSigninHandler(request).get_token_from_cache():
            # If the user is authenticated
            if request.user.is_authenticated:
                return self.get_response(request)
        return redirect("azure_signin:login")
