#!/bin/bash

GH_TOKEN=$1
PLUGIN_PATH=$2
REPO_LIST=$(./get_repo_list_from_github.sh $GH_TOKEN) #获取仓库列表

rm -rf $(pwd)/backup_repo                           #删除backup_repo文件夹以免产生冲突
bash -x $PLUGIN_PATH/download.sh $(pwd)/backup_repo #下载备份汇总仓库到backup_repo文件夹
cd $(pwd)/backup_repo                               #进入备份汇总仓库

while read REPO_NAME; do
    CLONE_URL=$(echo $REPO_LIST | jq -cr ".[\"$REPO_NAME\"]")
    MAIN_REPO_LOCAL="$(pwd)/main"
    BKUP_REPO_COMPRESS="$(pwd)/$REPO_NAME.tar.gz"
    BKUP_REPO_LOCAL="$(pwd)/bkup"
    bash -x ../download_repo.sh "$CLONE_URL" "$MAIN_REPO_LOCAL"                                      #下载主仓库
    bash -x ../backup_to_local_tar.gz.sh "$MAIN_REPO_LOCAL" "$BKUP_REPO_COMPRESS" "$BKUP_REPO_LOCAL" #备份到压缩文件
    rm -rf "$MAIN_REPO_LOCAL"
done <<<$(echo $REPO_LIST | jq -cr 'keys_unsorted | .[]')

cd ..
bash -x $PLUGIN_PATH/upload.sh $(pwd)/backup_repo #上传备份汇总仓库
rm -rf $(pwd)/backup_repo
