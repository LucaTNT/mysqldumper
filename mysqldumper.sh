#!/usr/bin/env bash
set -euo pipefail

# (from https://github.com/databacker/mysql-backup/blob/master/functions.sh)
# Environment variable reading function
#
# The function enables reading environment variable from file.
#
# usage: file_env VAR [DEFAULT]
#    ie: file_env 'XYZ_DB_PASSWORD' 'example'
# (will allow for "$XYZ_DB_PASSWORD_FILE" to fill in the value of
#  "$XYZ_DB_PASSWORD" from a file, especially for Docker's secrets feature
function file_env() {
  local var="$1"
  local fileVar="${var}_FILE"
  local def="${2:-}"
  if [ "${!var:-}" ] && [ "${!fileVar:-}" ]; then
    echo >&2 "error: both $var and $fileVar are set (but are exclusive)"
    exit 1
  fi
  local val="$def"
  if [ "${!var:-}" ]; then
    val="${!var}"
  elif [ "${!fileVar:-}" ]; then
    val="$(< "${!fileVar}")"
  fi
  export "$var"="$val"
  unset "$fileVar"
}

# From https://github.com/djmaze/resticker/blob/master/backup
function run_commands {
    COMMANDS=$1
    while IFS= read -r cmd; do echo $cmd && eval $cmd ; done < <(printf '%s\n' "$COMMANDS")
}

function run_exit_commands {
    set +e
    set +o pipefail
    run_commands "${POST_COMMANDS_EXIT:-}"
}

trap run_exit_commands EXIT

run_commands "${PRE_COMMANDS:-}"

file_env DB_SERVER
file_env DB_USER
file_env DB_PASS
file_env DB_NAME
file_env OUT_PATH

if [[ -z $DB_SERVER ]]; then
    echo "Missing DB_SERVER (or DB_SERVER_FILE) env var";
    exit 1;
fi

if [[ -z $DB_USER ]]; then
    echo "Missing DB_USER (or DB_USER_FILE) env var";
    exit 1;
fi

if [[ -z $DB_PASS ]]; then
    echo "Missing DB_PASS (or DB_PASS_FILE) env var";
    exit 1;
fi

if [[ -z $DB_NAME ]]; then
    echo "Missing DB_NAME (or DB_NAME_FILE) env var";
    exit 1;
fi

if [[ -z $OUT_PATH ]]; then
    echo "Missing OUT_PATH (or OUT_PATH_FILE) env var";
    exit 1;
fi

start=`date +%s`
echo Starting Backup at $(date +"%Y-%m-%d %H:%M:%S")

set +e
if [[ ${COMPRESS:-true} == "true" ]]; then
    mysqldump --host="$DB_SERVER" --user="$DB_USER" --password="$DB_PASS" "$DB_NAME" | gzip > "$OUT_PATH"
else
    mysqldump --host="$DB_SERVER" --user="$DB_USER" --password="$DB_PASS" "$DB_NAME" > "$OUT_PATH"
fi

if [ $? -ne 0 ]; then
    set -e
    run_commands "${POST_COMMANDS_FAILURE:-}"
    exit
else
    set -e
fi

end=`date +%s`
echo Finished backup at $(date +"%Y-%m-%d %H:%M:%S") after $((end-start)) seconds

run_commands "${POST_COMMANDS_SUCCESS:-}"