#!/bin/bash

GH_TOKEN=$1
PLUGIN_PATH=$2
DAYS_AGO=$3
REPO_LIST=$(./get_repo_list_from_github.sh $GH_TOKEN $DAYS_AGO) #获取仓库列表
if [ "$REPO_LIST" = "{}" ]; then                                #没有仓库可备份的就退出
    echo '没有仓库需要备份'
    exit 0
fi

while read REPO_NAME; do
    CLONE_URL=$(echo $REPO_LIST | jq -cr ".[\"$REPO_NAME\"]")
    MAIN_REPO_LOCAL="$(pwd)/main"
    bash -x ../download_repo.sh "$CLONE_URL" "$MAIN_REPO_LOCAL"                         #下载主仓库
    bash -x ../backup_to_local_tar.gz.sh "$REPO_NAME" "$MAIN_REPO_LOCAL" "$PLUGIN_PATH" #备份到压缩文件
    rm -rf "$MAIN_REPO_LOCAL"                                                           #删除主仓库
done <<<$(echo $REPO_LIST | jq -cr 'keys_unsorted | .[]')
