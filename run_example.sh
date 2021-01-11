#!/bin/bash

DAYS_AGO='10'
echo "本次备份将在$DAYS_AGO天内有修改记录的仓库中进行"
if [ "$1" = '0' ]; then
    echo '备份自己'
    ./mirror_to_remote_repo.sh $(pwd) https://$GH_BKUP_TOKEN@github.com/yindaheng98backup/github-backup-ultimate
elif [ "$1" = '1' ]; then
    echo '备份到Gitee/Gitlab'
    REPO_PLUGINS="[\"plugins/make_repo_available/gitee.sh yindaheng98 $GE_TOKEN\",\"plugins/make_repo_available/gitlab.sh yindaheng98 $GL_TOKEN\"]"
    ./run_backup_to_remote.sh yindaheng98 $GH_TOKEN "$REPO_PLUGINS" $DAYS_AGO
else
    echo '备份到Aliyun OSS'
    PLUGIN_PATH=$(pwd)'/plugins/remote_filesystem/aliyun_oss'
    endpoint='oss-cn-hangzhou.aliyuncs.com'
    backupPath='oss://github-backup'
    $PLUGIN_PATH/configure.sh $accessKeyID $accessKeySecret $endpoint $backupPath
    ./run_backup_to_tar.gz.sh $GH_TOKEN $PLUGIN_PATH $DAYS_AGO
fi
