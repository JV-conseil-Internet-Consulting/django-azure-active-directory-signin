import json
import logging

logger = logging.getLogger(__name__)


def logger_debug(msg="", output={}, log=logger, *args, **kwargs):
    "logger_debug"
    try:
        msg += " %s"
        output = json.dumps(
            output,
            indent=4,
            sort_keys=True,
            skipkeys=[
                "CLIENT_SECRET",
            ],
        )
        log.debug(msg, output)
    except Exception as e:
        logger.exception(e)
