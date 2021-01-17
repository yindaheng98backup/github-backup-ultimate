#!/bin/bash

TOKEN=$1   # personal access token
PARAMS=$2  # GET链接的参数，JSON格式

param=''
#直接用管道符写while循环会开启新进程，使while里面的变量不能传到外部
while read K; do
    V=$(echo $PARAMS | jq -cr ".$K")
    if [ $K ]; then
        param=$param"$K=$V&"
    fi
done <<<$(echo $PARAMS | jq -cr 'keys | .[]')

REPOS_URL='https://api.github.com/user/repos?'$param
echo $(curl -H "Authorization: token $TOKEN" -s $REPOS_URL)
