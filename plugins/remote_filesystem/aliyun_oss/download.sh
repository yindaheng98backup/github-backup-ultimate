#!/bin/bash

LOCAL=$1
CONF_PATH=$(dirname ${BASH_SOURCE[0]})
REMOTE_PATH_FILE=$CONF_PATH/REMOTE_PATH
REMOTE=$(cat $REMOTE_PATH_FILE)
$CONF_PATH/cp.sh $REMOTE $LOCAL