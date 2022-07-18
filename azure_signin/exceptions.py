import json


class TokenError(Exception):
    """Token Error Sample

    ```json
    {
        "error": "invalid_grant",
        "error_description": "AADSTS501481: The Code_Verifier does not match the code_challenge supplied in the authorization request.
        Trace ID: 29492451-a7cf-4650-b530-e947042b5700
        Correlation ID: 50087be9-d2db-4e08-abd6-2746fe9af2d1
        Timestamp: 2022-07-18 15:50:01Z",
        "error_codes": [
            501481
        ],
        "timestamp": "2022-07-18 15:50:01Z",
        "trace_id": "29492451-a7cf-4650-b530-e947042b5700",
        "correlation_id": "50087be9-d2db-4e08-abd6-2746fe9af2d1"
    }
    ```
    """

    def __init__(self, token={}):
        self.token = token

    def __str__(self):
        if not self.token:
            return
        if isinstance(self.token, dict):
            return json.dumps(
                self.token,
                indent=4,
                skipkeys=[
                    "CLIENT_SECRET",
                ],
            )
        return str(self.token)


class InvalidAuthenticationToken(TokenError):
    """Invalid Authentication Token Sample

    ```json
    {
        "error": {
            "code": "InvalidAuthenticationToken",
            "innerError": {
                "client-request-id": "6609865e-44c4-40cc-a55b-ab78cbfce628",
                "date": "2022-07-17T15:54:29",
                "request-id": "6609865e-44c4-40cc-a55b-ab78cbfce628"
            },
            "message": "CompactToken parsing failed with error code: 80049217"
        }
    }
    ```
    """

    pass


class RenameAttributesValueError(ValueError):
    pass
