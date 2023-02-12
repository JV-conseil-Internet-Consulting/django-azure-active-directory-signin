#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
#
# author        : JV-conseil
# credits       : JV-conseil
# licence       : BSD 3-Clause License
# copyright     : Copyright (c) 2019-2023 JV-conseil
#                 All rights reserved
#====================================================



#
# Set PATH, MANPATH, etc., for Homebrew for M1
#
case $(arch) in
    arm64) # M1
        eval "$(/opt/homebrew/bin/brew shellenv)"
        export BREW_PREFIX=/opt/homebrew

    ;;
    i386) # Intel
        export BREW_PREFIX=/usr/local
    ;;
esac



#
# CONFIG
#
# shellcheck disable=SC1091
source ".bash/settings.conf"

for __path in "${__EXTRA_SOURCES[@]}"
do
    # shellcheck disable=SC1090
    source "${__path}"
done


#
# GLOBALS
#
export LANG="en_US.UTF-8"



#
# ALIAS
#
alias python=python3


#
# PATH
#
# export PYTHONPATH="/opt/homebrew/bin/python${__PYVERS}"
# export PATH="${PYTHONPATH}:$PATH"
# export LDFLAGS="-L${PYTHONPATH}/lib"
# export PKG_CONFIG_PATH="${PYTHONPATH}/lib/pkgconfig"
export PYTHONPATH="${BREW_PREFIX}/bin/python${__PYVERS}"
export PATH="${PYTHONPATH}/bin:$PATH"  # ${__PYVERS}: If you need to have ${__PYVERS} first in your PATH run
export LDFLAGS="-L${PYTHONPATH}/lib"
export PKG_CONFIG_PATH="${PYTHONPATH}/lib/pkgconfig"
export FOLDER_PATH="$HOME/GitHub/${__GH_ORGANIZATION}/${__GH_REPOSITORY}"



#
# capturing annoying source ~/virtualenvs/.../bin/activate
#
__capture_lines() {
    read -r -p ""
    if [[ -z "$REPLY" ]]
    then
        echo -e "press any key to continue\n"
    else
        echo -e "$REPLY\n"
    fi
}
