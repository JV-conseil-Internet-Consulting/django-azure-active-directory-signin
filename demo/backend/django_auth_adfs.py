import logging

from django_auth_adfs.backend import AdfsAuthCodeBackend


class CustomAdfsAuthCodeBackend(AdfsAuthCodeBackend):
    # def exchange_auth_code(self, authorization_code, request):
    #     output = super().exchange_auth_code(authorization_code, request)
    #     print("CustomAdfsAuthCodeBackend")
    #     print(output)
    #     return output

    def validate_access_token(self, access_token):
        output = super().validate_access_token(access_token)
        print("CustomAdfsAuthCodeBackend Token Details")
        print(output)
        return output
