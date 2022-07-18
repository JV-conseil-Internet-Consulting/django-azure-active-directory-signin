from django.urls import path

from azure_signin.views import azure_signin_callback, azure_signin_login, azure_signin_logout

app_name = "azure_signin"
urlpatterns = [
    path("login", azure_signin_login, name="login"),
    path("logout", azure_signin_logout, name="logout"),
    path("callback", azure_signin_callback, name="callback"),
    path("redirect", azure_signin_callback, name="redirect"),
]
