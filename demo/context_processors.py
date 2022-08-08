from azure_signin.configuration import AzureSigninConfig
from django.conf import settings
from django.urls import reverse


def context(request):
    claims = (
        request.identity_context_data._id_token_claims
        or request.session.get("id_token_claims")
        or {}
    )
    exclude_claims = ["iat", "exp", "nbf", "uti", "aio", "rh"]
    claims_to_display = {
        claim: value for claim, value in claims.items() if claim not in exclude_claims
    }

    aad_link = (
        "https://portal.azure.com/#blade/Microsoft_AAD_RegisteredApps/ApplicationMenuBlade/Authentication/appId/"
        + AzureSigninConfig.CLIENT_ID
        + "/isMSAApp/"
    )

    return dict(
        claims_to_display=claims_to_display,
        redirect_uri_external_link=request.build_absolute_uri(
            # reverse(settings.AAD_CONFIG.django.auth_endpoints.redirect)
            reverse("azure_signin:callback")
        ),
        aad_link=aad_link,
    )
