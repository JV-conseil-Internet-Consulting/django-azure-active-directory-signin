#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
#
# author        : JV-conseil
# credits       : JV-conseil
# copyright     : Copyright (c) 2019-2023 JV-conseil
#                 All rights reserved
#====================================================

# shellcheck disable=SC1091
source ".bash/osx/bash_alias.sh"

cd "$FOLDER_PATH" || exit

echo -e "\n\e[0;35mLaunching local server...\e[0;0m https://127.0.0.1:8000/\n"

open -n -a /Applications/Firefox.app --args "--new-tab" "https://127.0.0.1:8000/"

poetry run python manage.py runsslserver
