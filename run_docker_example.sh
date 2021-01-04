#!/bin/bash

# 随机选择是备份到远端仓库还是备份到Aliyun
# 因为备份很上传很耗时，不管备份到哪都50分钟内做不完
# 如果两个一起做那必有一个做不了
# 于是出此下策

./mirror_to_remote_repo.sh $(pwd) https://$GH_BKUP_TOKEN@github.com/yindaheng98backup/github-backup-ultimate
if [ $(($RANDOM % 2)) -eq 0 ]; then
    echo '这次备份到Gitee/Gitlab'
    REPO_PLUGINS="[\"plugins/make_repo_available/gitee.sh yindaheng98 $GE_TOKEN\",\"plugins/make_repo_available/gitlab.sh yindaheng98 $GL_TOKEN\"]"
    docker build -t temp -f ./run_backup_to_remote.Dockerfile \
    --build-arg USER=yindaheng98 \
    --build-arg GH_TOKEN=$GH_TOKEN \
    --build-arg REPO_PLUGINS="$REPO_PLUGINS"
    docker rmi temp
    docker run --rm -v '.:'
else
    echo '这次备份到Aliyun OSS'
    docker build -t temp -f ./run_backup_to_remote.Dockerfile \
    --build-arg GH_TOKEN=$GH_TOKEN \
    --build-arg PLUGIN_PATH=$(pwd)'/plugins/remote_filesystem/aliyun_oss'
    --build-arg accessKeyID=$accessKeyID
    --build-arg accessKeySecret=$accessKeySecret
    --build-arg endpoint='oss-cn-hangzhou.aliyuncs.com'
    --build-arg backupPath='oss://github-backup'
    docker rmi temp
fi
