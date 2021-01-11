#!/bin/bash

#下载并配置相关文件

accessKeyID=$1
accessKeySecret=$2
endpoint=$3
REMOTE_PATH=$4
CONF_PATH=$(dirname ${BASH_SOURCE[0]})
mkdir -p "$CONF_PATH/TEMP"
EXEC_FILE=$CONF_PATH/ossutil64
if ! [ -x $EXEC_FILE ]; then
    wget http://gosspublic.alicdn.com/ossutil/1.7.0/ossutil64 -O $EXEC_FILE
    chmod 755 $EXEC_FILE
fi
CONFIG_FILE=$CONF_PATH/.ossutilconfig
echo '[Credentials]' >$CONFIG_FILE
echo 'language=CH' >>$CONFIG_FILE
echo "accessKeyID=$accessKeyID" >>$CONFIG_FILE
echo "accessKeySecret=$accessKeySecret" >>$CONFIG_FILE
echo "endpoint=$endpoint" >>$CONFIG_FILE
CMD_FILE=$CONF_PATH/CMD.sh
echo "$EXEC_FILE -c $CONFIG_FILE" >$CMD_FILE
REMOTE_PATH_FILE=$CONF_PATH/REMOTE_PATH
echo "$REMOTE_PATH" >$REMOTE_PATH_FILE
