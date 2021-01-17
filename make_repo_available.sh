#!/bin/bash

#通过github上的仓库获取指定备份仓库clone url

GH_USER=$1
GH_TOKEN=$2
PLUGIN=$3
DAYS_AGO=$4
#这里的PLUGINS是一个仓库创建/修改/返回Clone URL插件列表：
# [ "./plugins/make_repo_available/gitee.sh 用户名 token ", "./plugins/make_repo_available/gitlab.sh 用户名 token ", ... ]
#列表里面的值后面只要加一个REPO_NAME和PRIVATE就能自动创建修改仓库然后返回仓库clone url

function get_backup_repo_list() {
    PARAMS=$1
    GH_TOKEN=$2
    PRIVATE=$3
    if [ "$PRIVATE" = "false" ]; then
        PARAMS=$(echo $PARAMS | jq -c ". + {\"visibility\": \"public\"}")
    else
        PARAMS=$(echo $PARAMS | jq -c ". + {\"visibility\": \"private\"}")
    fi
    CONTENTS=$(./github_api/get_repo_content_from_github.sh $GH_TOKEN $PARAMS) #获取仓库列表
    while read CONTENT; do
        REPO_NAME=$(echo $CONTENT | jq -cr '.name')
        DESCRIPTION=$(echo $CONTENT | jq -cr '.description')
        if [ "$CONTENT" ]; then
            eval "$PLUGIN '$REPO_NAME' '$PRIVATE' '$DESCRIPTION'"
        fi
    done <<<$(echo $CONTENTS | jq -c '.[] | {name: .name, description: .description}')
}

PARAMS='{}'
PARAMS=$(echo $PARAMS | jq -c ". + {\"affiliation\": \"owner\"}")
PARAMS=$(echo $PARAMS | jq -c ". + {\"per_page\": \"100\"}")
PARAMS=$(echo $PARAMS | jq -c ". + {\"sort\": \"updated\"}")
if [ $DAYS_AGO ]; then
    SINCE=$(date --date="$DAYS_AGO days ago" --iso-8601=seconds)
    PARAMS=$(echo $PARAMS | jq -c ". + {\"since\": \"$SINCE\"}")
fi
get_backup_repo_list "$PARAMS" "$GH_TOKEN" 'false'
get_backup_repo_list "$PARAMS" "$GH_TOKEN" 'true'
