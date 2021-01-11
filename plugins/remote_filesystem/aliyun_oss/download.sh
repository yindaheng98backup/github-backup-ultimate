#!/bin/bash

REPO_NAME=$1
LOCAL=$2
CONF_PATH=$(dirname ${BASH_SOURCE[0]})
REMOTE_PATH_FILE=$CONF_PATH/REMOTE_PATH
REPO_COMPRESS_REMOTE=$(cat $REMOTE_PATH_FILE)'/'$REPO_NAME'.tar.gz'
REPO_COMPRESS_LOCAL="$CONF_PATH/TEMP/$REPO_NAME.tar.gz"

$CONF_PATH/cp.sh $REPO_COMPRESS_REMOTE $REPO_COMPRESS_LOCAL #下载压缩文件
rm -rf $LOCAL && mkdir $LOCAL                               #创建文件夹
if [ -f $REPO_COMPRESS_LOCAL ]; then
    tar zxf $REPO_COMPRESS_LOCAL -C $LOCAL #解压压缩文件
    rm -rf $REPO_COMPRESS_LOCAL            #删除压缩文件
fi
