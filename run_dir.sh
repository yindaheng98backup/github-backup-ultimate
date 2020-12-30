#!/bin/bash

GH_USER=$1
GH_TOKEN=$2
GE_USER=$3
GE_TOKEN=$4
REPOS_URL=https://api.github.com/users/$GH_USER/repos?access_token="$GH_TOKEN"
GE_PREFIX='https://'$GE_TOKEN'@gitee.com/'$GE_USER
curl -s $REPOS_URL | jq -c '.[].clone_url' | while read URL; do
    echo "开始备份"$URL
    rm -rf ./main && mkdir ./main #下载待备份主仓库
    CLONE_URL=$(eval "echo $URL | sed 's/https:\/\/github.com/https:\/\/$GH_TOKEN@github.com/g'")
    REPO_NAME=$(eval "echo $URL | sed 's/.*'$USER'\/\(.*\).git$/\1/g'")
    ./getrepo.sh $CLONE_URL ./main
    cd ./main
    git push -u $GE_PREFIX'/'$REPO_NAME --all origin -f #直接强推到gitee
    #TODO: 仓库不存在时创建
    #TODO: 仓库私有情况与github一致
    cd ..
    rm -rf ./main
done