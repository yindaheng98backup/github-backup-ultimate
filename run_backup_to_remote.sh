#!/bin/bash

GH_USER=$1
GH_TOKEN=$2
REPO_PLUGINS=$3
DAYS_AGO=$4
REPO_LIST=$(./get_repo_list_from_github.sh $GH_TOKEN $DAYS_AGO) #获取仓库列表
if [ "$REPO_LIST" = "{}" ]; then                                    #没有仓库可备份的就退出
    echo '没有仓库需要备份'
    exit 0
fi

REMOTE_LIST=$(./get_backup_repo_list.sh $GH_USER $GH_TOKEN "$REPO_PLUGINS")
#这里REMOTE_LIST的值是一个JSON列表：
# {"github上的仓库名称": ["gitee上的备份仓库clone url", "gitlab上的备份仓库clone url", ...], ...}

while read REPO_NAME; do
    if [ $(echo "$REMOTE_LIST" | jq ". | has(\"$REPO_NAME\")") = "false" ]; then
        continue
    fi
    CLONE_URL=$(echo $REPO_LIST | jq -cr ".[\"$REPO_NAME\"]")
    MAIN_REPO_LOCAL="$(pwd)/main"
    BKUP_REPO_LOCAL="$(pwd)/bkup"
    bash -x ./download_repo.sh "$CLONE_URL" "$MAIN_REPO_LOCAL" #下载主仓库
    while read BKUP_REPO_REMOTE; do
        bash -x ./backup_to_remote_repo.sh "$MAIN_REPO_LOCAL" "$BKUP_REPO_REMOTE" "$BKUP_REPO_LOCAL" #备份到remote
    done <<<$(echo $REMOTE_LIST | jq ".[\"$REPO_NAME\"]" | jq -cr '.[]')
    rm -rf "$MAIN_REPO_LOCAL"
done <<<$(echo $REPO_LIST | jq -cr 'keys_unsorted | .[]')
