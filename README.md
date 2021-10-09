The purpose of this is to schedule and run mysqldump against the specified server, and save the results to a file.

## Configuration
Configuration happens through environment variables:

* `CRON_MINUTE`, `CRON_HOUR`, `CRON_DOM`, `CRON_MONTH` and `CRON_DOW` control the cronjob.
* `DB_SERVER` is the MySQL/MariaDB server host.
* `DB_USER` is the MySQL/MariaDB username.
* `DB_PASS` is the MySQL/MariaDB password.
* `DB_NAME` is the MySQL/MariaDB database name.
* `OUT_PATH` is the full output path for the dump. Usually on a volume/mount. This path must be writable by UID 1000, otherwise you'll need to edit the Dockerfile.
* `COMPRESS` if set to a literal "true", enables gzip compression of the dump file.
* `POST_COMMANDS_SUCCESS` contains commands to be executed after a successful backup.
* `POST_COMMANDS_FAILURE` contains commands to be executed after a failed backup.
* `POST_COMMANDS_EXIT` contains commands to be executed after the backup process, regardless of the result.
