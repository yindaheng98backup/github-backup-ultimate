#!/bin/bash

#将主仓库备份到一个远端仓库中

MAIN_REPO_LOCAL=$1  #主仓库本地目录
BKUP_REPO_REMOTE=$3 #备份仓库远端目录
BKUP_REPO_LOCAL=$2  #备份仓库本地目录
PREDIR=$(pwd)

rm -rf $BKUP_REPO_LOCAL && mkdir $BKUP_REPO_LOCAL
./download_repo.sh $BKUP_REPO_REMOTE $BKUP_REPO_LOCAL #下载仓库
./backup.sh $MAIN_REPO_LOCAL $BKUP_REPO_LOCAL         #执行备份
cd $BKUP_REPO_LOCAL
git push --all -f -u $BKUP_REPO_REMOTE #直接强推到远端

cd $PREDIR
rm -rf $BKUP_REPO_LOCAL
