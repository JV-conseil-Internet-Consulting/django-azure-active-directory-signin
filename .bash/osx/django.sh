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

_jvcl_::dj_create_superuser() {
  local _password _user

  _user=${USER:-"superuser"}
  _password=$(_jvcl_::key_gen 32)

  if echo "from django.contrib.auth import get_user_model; User = get_user_model(); User.objects.create_superuser('${_user}', '${_user}', '${_password}');" | poetry run python manage.py shell; then

    cat <<EOF

Username: ${_user}
Password: ${_password}

You will be able to test superuser access to the admin panel by visiting
https://localhost:8000/admin

EOF
  fi
}

if _jvcl_::ask "Do you want to delete 'db.sqlite3'"; then
  find . -type f -name "db.sqlite3" -print -delete
  find . -type f -path "*/migrations/*" -name "0*.py" -print -delete
fi

if _jvcl_::ask "Do you want to run migrations"; then
  poetry run python manage.py makemigrations
  poetry run python manage.py migrate
  echo
fi

if _jvcl_::ask "Do you want to create a superuser"; then
  _jvcl_::dj_create_superuser
fi
