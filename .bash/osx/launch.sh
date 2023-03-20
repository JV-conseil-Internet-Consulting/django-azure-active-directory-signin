#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
#
# author        : JV-conseil
# credits       : JV-conseil
# copyright     : Copyright (c) 2019-2023 JV-conseil
#                 All rights reserved
#====================================================

# shellcheck source=/dev/null
. ".bash/incl/all.sh"

open -na /Applications/Firefox.app --args "--new-tab" "https://localhost:8000/"

if [ "${DEBUG}" -eq 0 ]; then
  _jvcl_::h2 "Collecting Static files"
  poetry run python manage.py collectstatic --no-input
fi

poetry run python manage.py check --deploy 2>&1 | tee -a logfile.log
poetry run python manage.py runsslserver 2>&1 | tee -a logfile.log
