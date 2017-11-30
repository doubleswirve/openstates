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

echo "govhawk-exec-init" $state $(date)

export PYTHONPATH=./openstates

$PUPA_ENV/bin/pupa ${PUPA_ARGS:-} update $state "$@"

echo "govhawk-exec-time" $state $(convertsecs "$SECONDS") $SECONDS

if [ -n "${EXP_EXEC_TIME+1}" ] && [ "$SECONDS" -ge "$EXP_EXEC_TIME" ]; then
  echo "govhawk-exp-exec-time" $state $(convertsecs "$SECONDS") $SECONDS
fi

if [ "$SKIP_BILLY" = true ]; then
  exit 0
fi

export PUPA_DATA_DIR='../openstates/_data'
export PYTHONPATH=./billy_metadata/
$BILLY_ENV/bin/python -m pupa2billy.run $state
$BILLY_ENV/bin/billy-update $state --import --report
