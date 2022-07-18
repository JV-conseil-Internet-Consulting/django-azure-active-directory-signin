#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
#
# author        : JV conseil – Internet Consulting
# credits       : JV-conseil
# licence       : BSD 3-Clause License.
# copyright     : Copyright (c) 2022, JV conseil – Internet Consulting,
#                 All rights reserved.
#======================================================================


#
# GLOBALS
#
__PYVERS="python@3.9"


#
# PATH
#
export LANG="en_US.UTF-8"
export PATH="/usr/local/opt/${__PYVERS}/bin:$PATH"  # ${__PYVERS}: If you need to have ${__PYVERS} first in your PATH run
export PATH="/usr/local/opt/${__PYVERS}/bin:$PATH"  # ${__PYVERS}: If you need to have ${__PYVERS} first in your PATH run
export LDFLAGS="-L/usr/local/opt/${__PYVERS}/lib"
export PKG_CONFIG_PATH="/usr/local/opt/${__PYVERS}/lib/pkgconfig"
export PKG_NAME="django-azure-active-directory-signin"
export FOLDER_PATH="$HOME/GitHub/JV-conseil-Internet-Consulting/${PKG_NAME}"


#
# ENV
#
# shellcheck disable=SC1090,SC1091
source "$HOME/.env/${PKG_NAME}/.env"


#
# ALIAS
#
alias python=python3
