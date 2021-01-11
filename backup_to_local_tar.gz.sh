#!/bin/bash

#将主仓库备份到一个压缩包中

REPO_NAME=$1       #仓库名称
MAIN_REPO_LOCAL=$2 #主仓库本地目录
BKUP_REPO_LOCAL=$3 #备份仓库本地目录
PLUGIN_PATH=$4     #存储插件地址

changed=''
rm -rf $BKUP_REPO_LOCAL && mkdir $BKUP_REPO_LOCAL
bash -x $PLUGIN_PATH/download.sh $BKUP_REPO_NAME $BKUP_REPO_LOCAL #下载仓库
if [ -d $BKUP_REPO_LOCAL'/.git' ]; then                           #备份仓库git目录存在
    changed=$(./backup.sh $MAIN_REPO_LOCAL $BKUP_REPO_LOCAL)      #执行备份操作
else                                                              #备份仓库git目录不存在
    rm -rf $BKUP_REPO_LOCAL                                       #删除备份仓库
    cp -r $MAIN_REPO_LOCAL $BKUP_REPO_LOCAL                       #直接移动
    changed='1'
fi
if [ $changed ]; then                                               #如果被修改了
    bash -x $PLUGIN_PATH/upload.sh $BKUP_REPO_NAME $BKUP_REPO_LOCAL #就上传仓库
fi
rm -rf $BKUP_REPO_LOCAL
