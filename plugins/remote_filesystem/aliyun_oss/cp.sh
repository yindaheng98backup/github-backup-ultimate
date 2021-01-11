#!/bin/bash

SRC=$1
DST=$2
CONF_PATH=$(dirname ${BASH_SOURCE[0]})
OSS=$(cat $CONF_PATH/CMD.sh)
$OSS cp --update -f $SRC $DST --jobs 10
