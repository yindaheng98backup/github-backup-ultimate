#!/bin/bash

#通过github上的仓库获取指定备份仓库clone url

GH_USER=$1
GH_TOKEN=$2
SCRIPTS=$3
#这里的PLUGINS是一个仓库创建/修改/返回Clone URL插件列表：
# [ "./plugins/make_repo_available/gitee.sh 用户名 token ", "./plugins/make_repo_available/gitlab.sh 用户名 token ", ... ]
#列表里面的值后面只要加一个REPO_NAME和PRIVATE就能自动创建修改仓库然后返回仓库clone url

function get_backup_repo_list() {
    PARAMS=$1
    GH_TOKEN=$2
    PRIVATE=$3
    if [ $PRIVATE ]; then
        PARAMS=$(echo $PARAMS | jq -c ". + {\"visibility\": \"private\"}")
    else
        PARAMS=$(echo $PARAMS | jq -c ". + {\"visibility\": \"public\"}")
    fi
    REMOTE_LIST='{}'
    REPO_LIST=$(./get_repo_list_from_github.sh $GH_TOKEN $PARAMS) #获取仓库列表
    for REPO_NAME in $(echo $REPO_LIST | jq -cr 'keys | .[]'); do
        CLONE_URLS='[]'
        for SCRIPT in $(echo $SCRIPTS | jq -cr '.[]'); do
            CLONE_URL=$(eval "$SCRIPT $REPO_NAME $PRIVATE")
            CLONE_URLS=$(echo $CLONE_URLS | jq -c ". + [\"$CLONE_URL\"]")
        done
        REMOTE_LIST=$(echo $REMOTE_LIST | jq -c ". + {\"$REPO_NAME\": $CLONE_URLS}")
    done
    echo $REMOTE_LIST
}

PARAMS='{}'
PARAMS=$(echo $PARAMS | jq -c ". + {\"affiliation\": \"owner\"}")
PARAMS=$(echo $PARAMS | jq -c ". + {\"per_page\": \"100\"}")
PARAMS=$(echo $PARAMS | jq -c ". + {\"sort\": \"updated\"}")
REMOTE_LIST_PUBLIC=$(get_backup_repo_list "$PARAMS" "$GH_TOKEN")
REMOTE_LIST_PRIVATE=$(get_backup_repo_list "$PARAMS" "$GH_TOKEN" 'true')
REMOTE_LIST='{}'
REMOTE_LIST=$(echo $REMOTE_LIST | jq -c ". + $REMOTE_LIST_PUBLIC")
REMOTE_LIST=$(echo $REMOTE_LIST | jq -c ". + $REMOTE_LIST_PRIVATE")
echo $REMOTE_LIST
#这里REMOTE_LIST的值是一个JSON列表，格式见backup_all_to_remote.sh的说明
