#!/bin/bash

#创建仓库并修改仓库可见性

USER=$1
TOKEN=$2
REPO_NAME=$3
PRIVATE=$4
DESCRIPTION="$5"
HEADER='Content-Type: application/json;charset=UTF-8'
CREATE_URL='https://gitee.com/api/v5/user/repos'
POST_DATA="{\"access_token\":\"$TOKEN\",\"name\":\"$REPO_NAME\"}"
POST_DATA=$(echo "$POST_DATA" | jq --arg DESC "$DESCRIPTION" '. + {description: $DESC}')
POST_DATA=$(echo "$POST_DATA" | jq -c '. + {private: "true"}')
if [ "$PRIVATE" = 'false' ]; then
    POST_DATA=$(echo "$POST_DATA" | jq -c '. + {private: "false"}')
fi
curl -X POST --header "$HEADER" -s "$CREATE_URL" -d "$POST_DATA" | jq . #新建仓库

MODIFY_URL="https://gitee.com/api/v5/repos/$USER/$REPO_NAME"
curl -X PATCH --header "$HEADER" -s "$MODIFY_URL" -d "$POST_DATA" | jq . #修改已有仓库的private状态
