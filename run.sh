#!/bin/bash

GH_TOKEN=$4

PACKREPO_URL=$2
PACKREPO_BRANCH=$3
rm -rf ./.git                                             #删除backup仓库的.git结构
rm -rf ./backup_repo                                      #删除backup_repo文件夹以免产生冲突
git clone -b $PACKREPO_BRANCH $PACKREPO_URL ./backup_repo #下载备份汇总仓库到backup_repo文件夹
cd ./backup_repo                                          #进入备份汇总仓库
rm -rf ./.git                                             #删除备份汇总仓库原有的.git结构以免产生错误

function backup_repo() {
    URL=$1
    echo "开始备份"$URL
    rm -rf ./main && mkdir ./main
    rm -rf ./bkup && mkdir ./bkup
    ../getrepo.sh $CLONE_URL ./main #下载待备份主仓库
    CLONE_URL=$(eval "echo $url | sed 's/https:\/\/github.com/https:\/\/$GH_TOKEN@github.com/g'")
    REPO_NAME=$(eval "echo $url | sed 's/.*'$USER'\/\(.*\).git$/\1/g'")
    if [ -x "./$REPO_NAME.tar.gz" ]; then    #对应的备份仓库压缩文件存在
        tar zxvf $REPO_NAME.tar.gz -C ./bkup #解压备份仓库
        ../backup.sh ./main ./bkup           #执行备份操作
        rm -rf ./main                        #删除已备份主仓库
    else                                     #对应的备份仓库压缩文件不存在
        mv ./main ./bkup                     #直接移动
    fi
    tar -zcvf ./$REPO_NAME.tar.gz ./bkup/.git
    rm -rf ./bkup
}

USER=$1
REPOS_URL=https://api.github.com/users/$USER/repos?access_token="$GH_TOKEN"
curl -s $REPOS_URL | jq -c '.[].clone_url' | while read url; do
    backup_repo $url
done

git config user.name "TravisCI"
git config user.email "yindaheng98@163.com"
set -e
git init
git add -A
git commit -m 'TravisCI Backup'
set -e
git push -u $PACKREPO_URL HEAD:$PACKREPO_BRANCH --force
