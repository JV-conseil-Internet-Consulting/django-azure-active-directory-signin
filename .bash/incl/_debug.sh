#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
#
# author        : JV-conseil
# credits       : JV-conseil
# copyright     : Copyright (c) 2019-2023 JV-conseil
#                 All rights reserved
#====================================================

_jvcl_::debug() {
  if [[ "${DEBUG}" -eq 0 ]]; then
    return
  fi
  cat <<EOF


===============
 DEBUG LEVEL ${DEBUG}
===============

EOF

  cat /proc/version 2>/dev/null || :
  cat /etc/issue 2>/dev/null || :
  _jvcl_::set_show_options
  python --version || :

  if [[ "${DEBUG}" -gt 1 ]]; then

    if [[ "${DEBUG}" -gt 2 ]]; then

      echo "$(
        set -o posix
        set | sort
      )"

      if [[ "${DEBUG}" -gt 3 ]]; then
        # exec 2>>.bash/logfile.log
        exec {BASH_XTRACEFD}>>.bash/logfile.log
        set -x
      fi

    else

      echo
      env
      echo

    fi

    echo
    alias
    echo
  fi

}
