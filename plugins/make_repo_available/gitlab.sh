#!/bin/bash

#创建仓库并修改仓库可见性

USER=$1
TOKEN=$2
REPO_NAME=$3
PRIVATE=$4
DESCRIPTION="$5"
HEADER="Content-Type: application/json;charset=UTF-8"
TOKEN_HEADER="PRIVATE-TOKEN: $TOKEN"

POST_DATA='{"name": "'$REPO_NAME'", "path": "'$REPO_NAME'", "description": "'$DESCRIPTION'"}'
POST_DATA=$(echo "$POST_DATA" | jq -c '. + {visibility: "private"}')
if [ "$PRIVATE" = 'false' ]; then
    POST_DATA=$(echo "$POST_DATA" | jq -c '. + {visibility: "public"}')
fi

CREATE_URL='https://gitlab.com/api/v4/projects'
curl -X POST --header "$HEADER" -H "$TOKEN_HEADER" -s "$CREATE_URL" -d "$POST_DATA" | jq . #新建仓库

MODIFY_URL='https://gitlab.com/api/v4/projects/'$USER'%2F'$REPO_NAME
curl -X PUT --header "$HEADER" -H "$TOKEN_HEADER" -s "$MODIFY_URL" -d "$POST_DATA" | jq . #修改已有仓库的private状态
