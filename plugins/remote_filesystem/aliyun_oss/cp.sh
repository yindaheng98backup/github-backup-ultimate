#!/bin/bash

SRC=$1
DST=$2
CONF_PATH=$(dirname ${BASH_SOURCE[0]})
OSS=$(cat $CONF_PATH/CMD.sh)
rm $CONF_PATH/ossutil.log
$OSS cp --loglevel info --update -f $SRC $DST --jobs 10
cat $CONF_PATH/ossutil.log
