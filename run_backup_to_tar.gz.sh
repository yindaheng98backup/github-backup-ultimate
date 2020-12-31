#!/bin/bash

USER=$1
GH_TOKEN=$2
PACKREPO_URL=$3
PACKREPO_BRANCH=$4
rm -rf $(pwd)/backup_repo                                 #删除backup_repo文件夹以免产生冲突
git clone -b $PACKREPO_BRANCH $PACKREPO_URL ./backup_repo #下载备份汇总仓库到backup_repo文件夹
cd $(pwd)/backup_repo                                     #进入备份汇总仓库
rm -rf $(pwd)/.git                                        #删除备份汇总仓库原有的.git结构以免产生错误

PARAMS='{}'
PARAMS=$(echo $PARAMS | jq -c ". + {\"visibility\": \"all\"}")
PARAMS=$(echo $PARAMS | jq -c ". + {\"affiliation\": \"owner\"}")
PARAMS=$(echo $PARAMS | jq -c ". + {\"per_page\": \"100\"}")
REPO_LIST=$(bash -x ../get_repo_list_from_github.sh $GH_TOKEN $PARAMS) #获取仓库列表
echo $REPO_LIST | jq
while read REPO_NAME; do
    CLONE_URL=$(echo $REPO_LIST | jq -cr ".$REPO_NAME")
    MAIN_REPO_LOCAL="$(pwd)/main"
    BKUP_REPO_COMPRESS="$(pwd)/$REPO_NAME.tar.gz"
    BKUP_REPO_LOCAL="$(pwd)/bkup"
    bash -x ../download_repo.sh "$CLONE_URL" "$MAIN_REPO_LOCAL"                                      #下载主仓库
    bash -x ../backup_to_local_tar.gz.sh "$MAIN_REPO_LOCAL" "$BKUP_REPO_COMPRESS" "$BKUP_REPO_LOCAL" #备份到压缩文件
    rm -rf "$MAIN_REPO_LOCAL"
done <<<$(echo $REPO_LIST | jq -cr 'keys | .[]')

ls -lht
du -h --max-depth=1
set -e
git init
git config user.name "TravisCI"
git config user.email "yindaheng98@163.com"
git lfs track $(find . -type f -size +100M)
git add -A
git commit -m 'TravisCI Backup '$(date '+%Y%m%d%H%M%S')
set -e
git push -u $PACKREPO_URL HEAD:$PACKREPO_BRANCH --force

cd ..
