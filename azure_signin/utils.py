import json
import logging

logger = logging.getLogger(__name__)


def logger_debug(
    msg="",
    dct={},
    log=logger,
    sensitive_fields=[
        "access_token",
        "assertion",
        "client_secret",
        "id_token",
        "password",
        "refresh_token",
    ],
    *args,
    **kwargs
):
    "logger_debug"

    output = {}

    def wipe(dictionary, sensitive_fields=[]):
        "Masks sensitive info"
        for sensitive in sensitive_fields:
            if sensitive in dictionary.keys() or sensitive.upper() in dictionary.keys():
                dictionary[sensitive] = "********"

    try:
        output = dct.copy()
        wipe(output, sensitive_fields)
        msg += " %s"
        output = json.dumps(output, indent=4, sort_keys=True)
        log.debug(msg, output)
    except Exception as e:
        logger.exception(e)
