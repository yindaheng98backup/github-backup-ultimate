#!/bin/bash

#将github上的仓库备份到多个指定仓库

GH_USER=$1
GH_TOKEN=$2
REMOTE_LIST=$3
#这里REMOTE_LIST的值是一个JSON列表：
# {"github上的仓库名称": ["gitee上的备份仓库clone url", "gitlab上的备份仓库clone url", ...], ...}

PARAMS='{}'
PARAMS=$(echo $PARAMS | jq -c ". + {\"visibility\": \"all\"}")
PARAMS=$(echo $PARAMS | jq -c ". + {\"affiliation\": \"owner\"}")
PARAMS=$(echo $PARAMS | jq -c ". + {\"per_page\": \"100\"}")

REPO_LIST=$(./get_repo_list_from_github.sh $GH_TOKEN $PARAMS) #获取仓库列表
while read REPO_NAME; do
    CLONE_URL=$(echo $REPO_LIST | jq -cr ".[\"$REPO_NAME\"]")
    MAIN_REPO_LOCAL="$(pwd)/main"
    BKUP_REPO_LOCAL="$(pwd)/bkup"
    bash -x ./download_repo.sh "$CLONE_URL" "$MAIN_REPO_LOCAL" #下载主仓库
    while read BKUP_REPO_REMOTE; do
        bash -x ./backup_to_remote_repo.sh "$MAIN_REPO_LOCAL" "$BKUP_REPO_REMOTE" "$BKUP_REPO_LOCAL" #备份到remote
    done <<<$(echo $REMOTE_LIST | jq ".[\"$REPO_NAME\"]" | jq -cr '.[]')
    rm -rf "$MAIN_REPO_LOCAL"
done <<<$(echo $REPO_LIST | jq -cr 'keys | .[]')
