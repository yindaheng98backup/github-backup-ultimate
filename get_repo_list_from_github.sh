#!/bin/bash

TOKEN=$1  # personal access token
PARAMS=$2 # GET链接的参数，JSON格式
REPOS=$(./get_repo_content_from_github.sh $TOKEN $PARAMS '.[].clone_url')
echo $REPOS
