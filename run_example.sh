#!/bin/bash

DAYS_AGO='10'
if [ $2 ]; then
    DAYS_AGO=$2
fi
echo "本次备份将在$DAYS_AGO天内有修改记录的仓库中进行"
if [ "$1" = 'self' ]; then
    echo '备份自己'
    git push --all -f -u https://$GH_BKUP_TOKEN@github.com/yindaheng98backup/github-backup-ultimate
elif [ "$1" = 'gitee' ]; then
    echo '备份到Gitee'
    PLUGIN_PATH=$(pwd)'/plugins/remote_filesystem/git'
    bash -x ./make_repo_available.sh yindaheng98 $GH_TOKEN "plugins/make_repo_available/gitee.sh yindaheng98 $GE_TOKEN" $DAYS_AGO
    bash -x $PLUGIN_PATH/configure.sh 'gitee' 'yindaheng98' $GE_TOKEN
    bash -x ./backup_all_to_remote.sh 'yindaheng98' $GH_TOKEN $PLUGIN_PATH $DAYS_AGO
elif [ "$1" = 'gitlab' ]; then
    echo '备份到Gitlab'
    PLUGIN_PATH=$(pwd)'/plugins/remote_filesystem/git'
    bash -x ./make_repo_available.sh yindaheng98 $GH_TOKEN "plugins/make_repo_available/gitlab.sh yindaheng98 $GL_TOKEN" $DAYS_AGO
    bash -x $PLUGIN_PATH/configure.sh 'gitlab' 'yindaheng98' $GL_TOKEN
    bash -x ./backup_all_to_remote.sh 'yindaheng98' $GH_TOKEN $PLUGIN_PATH $DAYS_AGO
elif [ "$1" = 'bitbucket' ]; then
    echo '备份到Bitbucket'
    PLUGIN_PATH=$(pwd)'/plugins/remote_filesystem/git'
    bash -x ./make_repo_available.sh yindaheng98 $GH_TOKEN "plugins/make_repo_available/bitbucket.sh yindaheng98 $GB_TOKEN" $DAYS_AGO
    bash -x $PLUGIN_PATH/configure.sh 'bitbucket' 'yindaheng98' $GB_TOKEN
    bash -x ./backup_all_to_remote.sh 'yindaheng98' $GH_TOKEN $PLUGIN_PATH $DAYS_AGO
else
    echo '备份到Aliyun OSS'
    PLUGIN_PATH=$(pwd)'/plugins/remote_filesystem/aliyun_oss'
    endpoint='oss-cn-hangzhou.aliyuncs.com'
    backupPath='oss://github-backup'
    $PLUGIN_PATH/configure.sh $accessKeyID $accessKeySecret $endpoint $backupPath
    bash -x ./backup_all_to_remote.sh 'yindaheng98' $GH_TOKEN $PLUGIN_PATH $DAYS_AGO
fi
