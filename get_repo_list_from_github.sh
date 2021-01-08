#!/bin/bash

TOKEN=$1  # personal access token
PARAMS=$2 # GET链接的参数，JSON格式
REPOS='{}'
while read CONTENT; do
    REPO_NAME=$(echo $CONTENT | jq -cr '.name')
    CLONE_URL=$(echo $CONTENT | jq -cr '.clone_url' | sed "s/https:\/\/github.com/https:\/\/$TOKEN@github.com/g")
    REPOS=$(echo $REPOS | jq -c ". + {\"$REPO_NAME\": \"$CLONE_URL\"}")
done <<<$(./get_repo_content_from_github.sh $TOKEN $PARAMS | jq -c '.[] | {name: .name, clone_url: .clone_url}')
echo $REPOS
