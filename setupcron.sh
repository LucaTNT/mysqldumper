#!/usr/bin/env bash
set -euo pipefail

echo "${CRON_MINUTE:-0} ${CRON_HOUR:-1} ${CRON_DOM:-*} ${CRON_MONTH:-*} ${CRON_DOW:-*} bash /mysqldumper.sh" > /etc/crontabs/mysqldumper

crond -f -d 8