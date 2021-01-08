#!/bin/bash

TOKEN=$1  # personal access token
PARAMS=$2 # GET链接的参数，JSON格式
REPOS='{}'
while read URL; do
    CLONE_URL=$(eval "echo $URL | sed 's/https:\/\/github.com/https:\/\/$TOKEN@github.com/g'")
    REPO_NAME=$(eval "echo $URL | sed 's/.*\/\([^\/]*\).git$/\1/g'")
    REPOS=$(echo $REPOS | jq -c ". + {\"$REPO_NAME\": \"$CLONE_URL\"}")
done <<<$(./get_repo_content_from_github.sh $TOKEN $PARAMS | jq -c '.[].clone_url')
echo $REPOS
