#!/bin/bash

CONF_PATH=$(dirname ${BASH_SOURCE[0]})
OSS=$(cat $CONF_PATH/CMD.sh)
REMOTE_PATH_FILE=$CONF_PATH/REMOTE_PATH
REMOTE=$(cat $REMOTE_PATH_FILE)
echo $($OSS ls $REMOTE)
