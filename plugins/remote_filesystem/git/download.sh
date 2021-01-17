#!/bin/bash

#此脚本用于下载远程仓库
REPO_NAME=$1 #仓库名称
LOCAL=$2     #仓库目录
CONF_PATH=$(dirname ${BASH_SOURCE[0]})
PERFIX=$(cat $CONF_PATH/DOWNLOAD_PERFIX)
URL="$PERFIX/$REPO_NAME.git"
PRE=$(pwd)
rm -rf $LOCAL
git clone --mirror $URL $LOCAL/.git #下载仓库中的所有branch
cd $LOCAL
git config --bool core.bare false
git checkout --
cd $PRE
