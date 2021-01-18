#!/bin/bash

#创建仓库并修改仓库可见性

USER=$1
TOKEN=$2
REPO_NAME=$3
PRIVATE=$4
DESCRIPTION="$5"
HEADER='Content-Type: application/json;charset=UTF-8'
URL='https://api.bitbucket.org/2.0/repositories/'$USER'/'$REPO_NAME
POST_DATA='{"scm": "git","project": {"key": "BACKUP"}}'
POST_DATA=$(echo "$POST_DATA" | jq --arg DESC "$DESCRIPTION" '. + {description: $DESC}')
POST_DATA=$(echo "$POST_DATA" | jq -c '. + {is_private: "true"}')
if [ $PRIVATE = 'false' ]; then
    POST_DATA=$(echo "$POST_DATA" | jq -c '. + {is_private: "false"}')
fi
curl -X PUT --user "$USER:$TOKEN" --header "$HEADER" -s "$URL" -d "$POST_DATA" | jq . #新建仓库
