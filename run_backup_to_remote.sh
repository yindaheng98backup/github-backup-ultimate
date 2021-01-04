#!/bin/bash

USER=$1
GH_TOKEN=$2
REPO_PLUGINS=$3
BACKUP_REPO_LIST=$(./get_backup_repo_list.sh $USER $GH_TOKEN "$REPO_PLUGINS")
./backup_all_to_remote.sh $USER $GH_TOKEN $BACKUP_REPO_LIST
