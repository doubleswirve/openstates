#!/bin/bash

set -e

#PUPA_ENV=~/.virtualenvs/pupa
#BILLY_ENV=~/.virtualenvs/openstates

convertsecs() {
  ((h=${1}/3600))
  ((m=(${1}%3600)/60))
  ((s=${1}%60))
  printf "%02d:%02d:%02d\n" $h $m $s
}

# copy use shift to get rid of first param, pass rest to pupa update
state=$1
shift

export PYTHONPATH=./openstates

$PUPA_ENV/bin/pupa ${PUPA_ARGS:-} update $state "$@"

echo "govhawkexecutiontime " $(convertsecs "$SECONDS")

if [ "$SKIP_BILLY" = true ]; then
  exit 0
fi

export PUPA_DATA_DIR='../openstates/_data'
export PYTHONPATH=./billy_metadata/
$BILLY_ENV/bin/python -m pupa2billy.run $state
$BILLY_ENV/bin/billy-update $state --import --report
