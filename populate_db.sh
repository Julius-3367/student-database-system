#!/usr/bin/env bash
# populate_db.sh - run migrations and seed data
# Usage: ./populate_db.sh -u user -h host -p
# It will prompt for password interactively.

set -euo pipefail
USER="root"
HOST="localhost"
PORT=3306
# Parse args
while getopts ":u:h:P:" opt; do
  case ${opt} in
    u ) USER=$OPTARG ;;
    h ) HOST=$OPTARG ;;
    P ) PORT=$OPTARG ;;
    \? ) echo "Usage: $0 [-u user] [-h host] [-P port]"; exit 1 ;;
  esac
done

MYSQL_CMD="mysql -u ${USER} -h ${HOST} -P ${PORT} -p"

echo "This script will run migrations/*.sql in order and then import seed data. You will be prompted for the DB password."
read -p "Press Enter to continue or CTRL-C to abort..."

# Run migrations in order
for f in migrations/*.sql; do
  echo "Applying $f"
  $MYSQL_CMD < "$f"
done

# Apply seed
echo "Applying seed data"
$MYSQL_CMD < student_records_seed.sql

echo "Done."
