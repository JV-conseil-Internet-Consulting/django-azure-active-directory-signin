#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
#
# author        : JV conseil – Internet Consulting
# credits       : JV-conseil
# licence       : BSD 3-Clause License.
# copyright     : Copyright (c) 2022, JV conseil – Internet Consulting,
#                 All rights reserved.
#======================================================================


# shellcheck disable=SC1091
source ".bash/bash_alias.sh"


cd "$FOLDER_PATH" || exit


open -n -a /Applications/Firefox.app --args "--new-tab" "https://127.0.0.1:8000"
# pipenv shell python manage.py runsslserver
poetry run python manage.py runsslserver