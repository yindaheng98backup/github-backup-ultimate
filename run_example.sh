#!/bin/bash

# 随机选择是备份到远端仓库还是备份到Aliyun
# 因为备份很上传很耗时，不管备份到哪都50分钟内做不完
# 如果两个一起做那必有一个做不了
# 于是出此下策

./mirror_to_remote_repo.sh $(pwd) https://$GH_BKUP_TOKEN@github.com/yindaheng98backup/github-backup-ultimate
if [ $(($RANDOM % 2)) -eq 0 ]; then
    echo '这次备份到Gitee/Gitlab'
    REPO_PLUGINS="[\"plugins/make_repo_available/gitee.sh yindaheng98 $GE_TOKEN\",\"plugins/make_repo_available/gitlab.sh yindaheng98 $GL_TOKEN\"]"
    ./run_backup_to_remote.sh yindaheng98 $GH_TOKEN "$REPO_PLUGINS"
else
    echo '这次备份到Aliyun OSS'
    PLUGIN_PATH=$(pwd)'/plugins/remote_filesystem/aliyun_oss'
    endpoint='oss-cn-hangzhou.aliyuncs.com'
    backupPath='oss://github-backup'
    $PLUGIN_PATH/configure.sh $accessKeyID $accessKeySecret $endpoint $backupPath
    ./run_backup_to_tar.gz.sh $GH_TOKEN $PLUGIN_PATH
fi
