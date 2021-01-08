#!/bin/bash

TOKEN=$1   # personal access token
PARAMS=$2  # GET链接的参数，JSON格式
CONTENT=$3 #要获取什么内容？

param=''
#直接用管道符写while循环会开启新进程，使while里面的变量不能传到外部
while read K; do
    V=$(echo $PARAMS | jq -cr ".$K")
    if [ $K ]; then
        param=$param"$K=$V&"
    fi
done <<<$(echo $PARAMS | jq -cr 'keys | .[]')

REPOS_URL='https://api.github.com/user/repos?'$param
REPOS='{}'
while read URL; do
    CTT=$(eval "echo $URL | sed 's/https:\/\/github.com/https:\/\/$TOKEN@github.com/g'")
    REPO_NAME=$(eval "echo $URL | sed 's/.*\/\([^\/]*\).git$/\1/g'")
    REPOS=$(echo $REPOS | jq -c ". + {\"$REPO_NAME\": \"$CTT\"}")
done <<<$(curl -H "Authorization: token $TOKEN" -s $REPOS_URL | jq -c $CONTENT)
echo $REPOS
