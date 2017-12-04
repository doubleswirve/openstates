#!/bin/bash

echo $MYSQL_HOST
echo $MYSQL_USER
echo $MYSQL_PASSWORD

until mysql -h "${MYSQL_HOST:-"localhost"}" -u "${MYSQL_USER:-"root"}" -p"${MYSQL_PASSWORD:-""}" -e "SHOW DATABASES"; do
  sleep 1
done

$PUPA_ENV/bin/python -m openstates.ca.download
