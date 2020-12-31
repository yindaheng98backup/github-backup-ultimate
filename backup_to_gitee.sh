#!/bin/bash

DIR=$1
USER=$2
TOKEN=$3
REPO_NAME=$4
PRIVATE=$5
PREDIR=$(pwd)
cd $DIR
CREATE_URL='https://gitee.com/api/v5/user/repos'
CREATE_HEADER='Content-Type: application/json;charset=UTF-8'
CREATE_POST="{'access_token':'$TOKEN','name':'$REPO_NAME'}"
if [ $PRIVATE ]; then
    CREATE_POST="{'access_token':'$TOKEN','name':'$REPO_NAME','private':'true'}"
fi
curl -X POST --header $CREATE_HEADER $CREATE_URL -d $CREATE_POST #先新建仓库
REMOTE='https://'$USER':'$TOKEN'@gitee.com/'$USER'/'$REPO_NAME
git push --all -f -u $REMOTE #直接强推到gitee
cd $PREDIR
