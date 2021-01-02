#!/bin/bash

#创建仓库并返回仓库clone地址

USER=$1
TOKEN=$2
REPO_NAME=$3
PRIVATE=$4
HEADER='Content-Type: application/json;charset=UTF-8'
CREATE_URL='https://gitee.com/api/v5/user/repos'
POST_DATA="{\"access_token\":\"$TOKEN\",\"name\":\"$REPO_NAME\"}"
POST_DATA=$(echo "$POST_DATA" | jq -c '. + {private: "false"}')
if [ $PRIVATE ]; then
    POST_DATA=$(echo "$POST_DATA" | jq -c '. + {private: "true"}')
fi
curl -X POST --header "$HEADER" -s "$CREATE_URL" -d "$POST_DATA" | jq . >&2 #新建仓库

MODIFY_URL="https://gitee.com/api/v5/repos/$USER/$REPO_NAME"
curl -X PATCH --header "$HEADER" -s "$MODIFY_URL" -d "$POST_DATA" | jq . >&2 #修改已有仓库的private状态

echo 'https://'$USER':'$TOKEN'@gitee.com/'$USER'/'$REPO_NAME
