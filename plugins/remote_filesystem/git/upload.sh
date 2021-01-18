#!/bin/bash

#此脚本用于下载远程仓库
REPO_NAME=$1 #仓库名称
LOCAL=$2     #仓库目录
URL=$($(dirname ${BASH_SOURCE[0]})/url_process.sh $REPO_NAME)
PRE=$(pwd)
cd $LOCAL
git push --all -f -u $URL #直接强推到远端
cd $PRE
