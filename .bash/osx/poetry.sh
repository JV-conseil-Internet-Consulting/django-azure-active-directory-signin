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

# How do I trim leading and trailing whitespace from each line of some output?
# See https://unix.stackexchange.com/a/102229/473393
_jvcl_::poetry_export_requirements() {
  poetry export --without-hashes -f requirements.txt --output requirements.txt
  poetry export --with dev --without-hashes -f requirements.txt --output requirements-full.txt

  comm -3 requirements.txt requirements-full.txt | awk '{$1=$1};1' >requirements-dev.txt
  rm -rf requirements-full.txt
}

_jvcl_::poetry_install() {
  find . -type f -name "poetry.lock" -print -delete

  poetry env use "${PYTHONPATH}"
  poetry check
  poetry install
  poetry update
  poetry show --tree
  echo
}

# Bash equivalent of Python if __name__ == "__main__":
# <https://stackoverflow.com/a/70662116/2477854>
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
  if _jvcl_::brew_install_formula "poetry"; then
    _jvcl_::poetry_install
    _jvcl_::poetry_export_requirements
  fi
fi
