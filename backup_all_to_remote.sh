#!/bin/bash

GH_TOKEN=$1
PLUGIN_PATH=$2
DAYS_AGO=$3

TOKEN=$GH_TOKEN # personal access token
PARAMS='{}'     # GET链接的参数，JSON格式
PARAMS=$(echo $PARAMS | jq -c ". + {\"visibility\": \"all\"}")
PARAMS=$(echo $PARAMS | jq -c ". + {\"affiliation\": \"owner\"}")
PARAMS=$(echo $PARAMS | jq -c ". + {\"per_page\": \"100\"}")
PARAMS=$(echo $PARAMS | jq -c ". + {\"sort\": \"updated\"}")
if [ $DAYS_AGO ]; then
    SINCE=$(date --date="$DAYS_AGO days ago" --iso-8601=seconds)
    PARAMS=$(echo $PARAMS | jq -c ". + {\"since\": \"$SINCE\"}")
fi
REPOS='{}'
while read CONTENT; do
    if ! [ $CONTENT ]; then
        continue
    fi
    REPO_NAME=$(echo $CONTENT | jq -cr '.name')
    CLONE_URL=$(echo $CONTENT | jq -cr '.clone_url' | sed "s/https:\/\/github.com/https:\/\/$TOKEN@github.com/g")
    REPOS=$(echo $REPOS | jq -c ". + {\"$REPO_NAME\": \"$CLONE_URL\"}")
done <<<$(./github_api/get_repo_content_from_github.sh $TOKEN $PARAMS | jq -c '.[] | {name: .name, clone_url: .clone_url}')
echo $REPOS

REPO_LIST=$REPOS                 #获取仓库列表
if [ "$REPO_LIST" = "{}" ]; then #没有仓库可备份的就退出
    echo '没有仓库需要备份'
    exit 0
fi

MAIN_REPO_LOCAL="$(pwd)/main"
rm -rf "$MAIN_REPO_LOCAL" #删除主仓库
while read REPO_NAME; do
    CLONE_URL=$(echo $REPO_LIST | jq -cr ".[\"$REPO_NAME\"]")
    bash -x ./backup_to_remote.sh "$REPO_NAME" "$MAIN_REPO_LOCAL" "$PLUGIN_PATH" #备份
    rm -rf "$MAIN_REPO_LOCAL"                                                    #删除主仓库
done <<<$(echo $REPO_LIST | jq -cr 'keys_unsorted | .[]')
