#!/bin/bash

SRC=$1
DST=$2
CONF_PATH=$(dirname ${BASH_SOURCE[0]})
OSS=$(cat $CONF_PATH/CMD.sh)
rm $CONF_PATH/ossutil.log
$OSS cp --loglevel info --recursive --update -f $SRC $DST
cat $CONF_PATH/ossutil.log
