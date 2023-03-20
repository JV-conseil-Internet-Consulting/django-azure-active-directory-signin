#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
#
# author        : JV-conseil
# credits       : JV-conseil
# copyright     : Copyright (c) 2019-2023 JV-conseil
#                 All rights reserved
#====================================================

# shellcheck source=/dev/null
{
  . ".bash/incl/all.sh"
  . ".bash/osx/poetry.sh"
}

_jvcl_::h1 "Poetry Update..."

poetry update
_jvcl_::poetry_export_requirements
