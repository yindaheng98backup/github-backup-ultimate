#!/bin/bash

#配置相关文件

PLATFORM=$1
USER=$2
TOKEN=$3
CONF_PATH=$(dirname ${BASH_SOURCE[0]})/url_process.sh
if [ "$PLATFORM" = 'github' ]; then
    PERFIX="https://$TOKEN@github.com/$USER"
    echo "echo $PERFIX/\$1" >$CONF_PATH
elif [ "$PLATFORM" = 'gitee' ]; then
    PERFIX="https://$USER:$TOKEN@gitee.com/$USER"
    echo "echo $PERFIX/\$1" >$CONF_PATH
elif [ "$PLATFORM" = 'gitlab' ]; then
    PERFIX="https://$USER:$TOKEN@gitlab.com/$USER"
    echo "echo $PERFIX/\${1//./-}" >$CONF_PATH
elif [ "$PLATFORM" = 'bitbucket' ]; then
    PERFIX="https://$USER:$TOKEN@bitbucket.org/$USER"
    echo "echo $PERFIX/\${1,,}" >$CONF_PATH
else
    rm -f $CONF_PATH
fi
