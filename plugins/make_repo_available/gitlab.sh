#!/bin/bash

#创建仓库并返回仓库clone地址

USER=$1
TOKEN=$2
REPO_NAME=$3
PRIVATE=$4
HEADER="PRIVATE-TOKEN: $TOKEN"
CREATE_URL='https://gitlab.com/api/v4/projects?name='$REPO_NAME
if [ $PRIVATE ]; then
    CREATE_URL=$CREATE_URL'&visibility=private'
else
    CREATE_URL=$CREATE_URL'&visibility=public'
fi
curl -X POST --header "$HEADER" -s "$CREATE_URL" | jq . >&2 #新建仓库

MODIFY_URL='https://gitlab.com/api/v4/projects/'$USER'%2F'$REPO_NAME
if [ $PRIVATE ]; then
    MODIFY_URL=$MODIFY_URL'?visibility=private'
else
    MODIFY_URL=$MODIFY_URL'?visibility=public'
fi
curl -X PUT --header "$HEADER" -s "$MODIFY_URL" | jq . >&2 #修改已有仓库的private状态

echo 'https://'$USER':'$TOKEN'@gitlab.com/'$USER'/'$REPO_NAME
