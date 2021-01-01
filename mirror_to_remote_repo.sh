#!/bin/bash

#将主仓库直接镜像到一个远端仓库中

MAIN_REPO_LOCAL=$1  #主仓库本地目录
BKUP_REPO_REMOTE=$3 #备份仓库远端目录
PREDIR=$(pwd)
cd $MAIN_REPO_LOCAL
GIT_CURL_VERBOSE=1 GIT_TRACE=1 git push --all -f -u $BKUP_REPO_REMOTE #直接强推到远端
cd $PREDIR
