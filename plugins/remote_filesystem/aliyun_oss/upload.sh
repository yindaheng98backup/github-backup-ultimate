#!/bin/bash

REPO_NAME=$1
LOCAL=$2
CONF_PATH=$(dirname ${BASH_SOURCE[0]})
REMOTE_PATH_FILE=$CONF_PATH/REMOTE_PATH
REPO_COMPRESS_REMOTE=$(cat $REMOTE_PATH_FILE)'/'$REPO_NAME'.tar.gz'
REPO_COMPRESS_LOCAL="$CONF_PATH/TEMP/$REPO_NAME.tar.gz"

if [ -d $LOCAL'/.git' ]; then
    PRE_DIR=$(pwd)
    cd $LOCAL
    tar -zcf $REPO_COMPRESS_LOCAL ./.git                        # 打压缩文件
    $CONF_PATH/cp.sh $REPO_COMPRESS_LOCAL $REPO_COMPRESS_REMOTE #上传压缩文件
    rm -rf $REPO_COMPRESS_LOCAL                                 #删除压缩文件
    cd $PRE_DIR
fi
