The purpose of this is to schedule and run mysqldump against the specified server, and save the results to a file.

## Configuration
Configuration happens through environment variables:

* `CRON_MINUTE`, `CRON_HOUR`, `CRON_DOM`, `CRON_MONTH` and `CRON_DOW` control the cronjob.
* `TZ` sets the time zone (e.g. Europe/Rome).
* `DB_SERVER` is the MySQL/MariaDB server host.
* `DB_USER` is the MySQL/MariaDB username.
* `DB_PASS` is the MySQL/MariaDB password.
* `DB_NAME` is the MySQL/MariaDB database name.
* `OUT_PATH` is the full output path for the dump. Usually on a volume/mount. This path must be writable by UID 1001, otherwise you'll need to edit the Dockerfile.
* `COMPRESS` if set to a literal "true", enables gzip compression of the dump file.
* `PRE_COMMANDS` contains commands to be executed before starting a backup.
* `POST_COMMANDS_SUCCESS` contains commands to be executed after a successful backup.
* `POST_COMMANDS_FAILURE` contains commands to be executed after a failed backup.
* `POST_COMMANDS_EXIT` contains commands to be executed after the backup process, regardless of the result.

# Docker secrets
`DB_SERVER`, `DB_USER`, `DB_PASS`, `DB_NAME`, `OUT_PATH` can be replaced with `DB_SERVER_FILE`, `DB_USER_FILE`, `DB_PASS_FILE`, `DB_NAME_FILE`, `OUT_PATH_FILE`: the contents of such files will be used as the value. This allows you to use Docker secrets.
