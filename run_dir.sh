#!/bin/bash

GH_USER=$1
GH_TOKEN=$2
GE_USER=$3
GE_TOKEN=$4

HEADER="Authorization: token $GH_TOKEN"
PUBLIC_REPOS_URL='https://api.github.com/user/repos?visibility=public&affiliation=owner&per_page=100'
PRIVATE_REPOS_URL='https://api.github.com/user/repos?visibility=private&affiliation=owner&per_page=100'
curl -H $HEADER -s $PUBLIC_REPOS_URL | jq -c '.[].clone_url' | while read URL; do
    echo "开始备份公开仓库"$URL
    rm -rf ./main && mkdir ./main #下载待备份主仓库
    CLONE_URL=$(eval "echo $URL | sed 's/https:\/\/github.com/https:\/\/$GH_TOKEN@github.com/g'")
    REPO_NAME=$(eval "echo $URL | sed 's/.*'$GH_USER'\/\(.*\).git$/\1/g'")
    ./getrepo.sh $CLONE_URL ./main
    ./backup_to_gitee.sh $(pwd)/main $GE_USER $GE_TOKEN $REPO_NAME ''
    rm -rf ./main
done
curl -H $HEADER -s $PRIVATE_REPOS_URL | jq -c '.[].clone_url' | while read URL; do
    echo "开始备份私有仓库"$URL
    rm -rf ./main && mkdir ./main #下载待备份主仓库
    CLONE_URL=$(eval "echo $URL | sed 's/https:\/\/github.com/https:\/\/$GH_TOKEN@github.com/g'")
    REPO_NAME=$(eval "echo $URL | sed 's/.*'$GH_USER'\/\(.*\).git$/\1/g'")
    ./getrepo.sh $CLONE_URL ./main
    ./backup_to_gitee.sh $(pwd)/main $GE_USER $GE_TOKEN $REPO_NAME 'true'
    rm -rf ./main
done