#!/bin/bash

GH_TOKEN=$4

PACKREPO_URL=$2
PACKREPO_BRANCH=$3
rm -rf $(pwd)/.git                                        #删除backup仓库的.git结构
rm -rf $(pwd)/backup_repo                                 #删除backup_repo文件夹以免产生冲突
git clone -b $PACKREPO_BRANCH $PACKREPO_URL ./backup_repo #下载备份汇总仓库到backup_repo文件夹
cd $(pwd)/backup_repo                                     #进入备份汇总仓库

USER=$1
REPOS_URL=https://api.github.com/users/$USER/repos?access_token="$GH_TOKEN"
curl -s $REPOS_URL | jq -c '.[].clone_url' | while read URL; do
    echo "开始备份"$URL

    rm -rf ./main && mkdir ./main #下载待备份主仓库
    CLONE_URL=$(eval "echo $URL | sed 's/https:\/\/github.com/https:\/\/$GH_TOKEN@github.com/g'")
    REPO_NAME=$(eval "echo $URL | sed 's/.*'$USER'\/\(.*\).git$/\1/g'")
    ../getrepo.sh $CLONE_URL $(pwd)/main

    rm -rf ./bkup && mkdir ./bkup                 #构建备份仓库
    if [ -x "$(pwd)/$REPO_NAME.git" ]; then       #对应的备份仓库.git文件夹存在
        mv $(pwd)/$REPO_NAME.git $(pwd)/bkup/.git #构建备份仓库
        ../backup.sh $(pwd)/main $(pwd)/bkup      #执行备份操作
    else                                          #备份仓库git目录不存在
        mv $(pwd)/main/.git $(pwd)/bkup/.git      #直接移动
    fi
    rm -rf ./main                             #删除已备份主仓库
    mv $(pwd)/bkup/.git $(pwd)/$REPO_NAME.git #移动到已备份仓库
    rm -rf ./bkup                             #删除备份仓库
done

ls -lht
du -h --max-depth=2
set -e
git config user.name "TravisCI"
git config user.email "yindaheng98@163.com"
git add -A
git commit -m 'TravisCI Backup '$(date '+%Y%m%d%H%M%S')
set -e
git push -u $PACKREPO_URL HEAD:$PACKREPO_BRANCH --force
