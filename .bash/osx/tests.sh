#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
#
# author        : JV-conseil
# credits       : JV-conseil
# licence       : BSD 3-Clause License
# copyright     : Copyright (c) 2019-2023 JV-conseil
#                 All rights reserved
#====================================================


# shellcheck disable=SC1091
source ".bash/osx/bash_alias.sh"


cd "$FOLDER_PATH" || exit

poetry run pytest
