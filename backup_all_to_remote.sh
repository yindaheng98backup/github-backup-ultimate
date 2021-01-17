#!/bin/bash

GH_TOKEN=$1
PLUGIN_PATH=$2
DAYS_AGO=$3

PARAMS='{}'     # GET链接的参数，JSON格式
PARAMS=$(echo $PARAMS | jq -c ". + {\"visibility\": \"all\"}")
PARAMS=$(echo $PARAMS | jq -c ". + {\"affiliation\": \"owner\"}")
PARAMS=$(echo $PARAMS | jq -c ". + {\"per_page\": \"100\"}")
PARAMS=$(echo $PARAMS | jq -c ". + {\"sort\": \"updated\"}")
if [ $DAYS_AGO ]; then
    SINCE=$(date --date="$DAYS_AGO days ago" --iso-8601=seconds)
    PARAMS=$(echo $PARAMS | jq -c ". + {\"since\": \"$SINCE\"}")
fi
MAIN_REPO_LOCAL="$(pwd)/main"
rm -rf "$MAIN_REPO_LOCAL" #删除主仓库
while read REPO_NAME; do
    if ! [ $REPO_NAME ]; then
        continue
    fi
    REPO_NAME=$(echo $CONTENT | jq -cr '.name')
    bash -x ./github_api/download_repo.sh "$REPO_NAME" "$MAIN_REPO_LOCAL" "$PLUGIN_PATH" #备份
    bash -x ./backup_to_remote.sh "$REPO_NAME" "$MAIN_REPO_LOCAL" "$PLUGIN_PATH" #备份
    rm -rf "$MAIN_REPO_LOCAL"                                                    #删除主仓库
done <<<$(./github_api/get_repo_content_from_github.sh $GH_TOKEN $PARAMS | jq -cr '.[] | .name')
echo $REPOS
