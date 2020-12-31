#!/bin/bash

#将主仓库备份到一个压缩包中

MAIN_REPO_LOCAL=$1    #主仓库本地目录
BKUP_REPO_COMPRESS=$2 #备份仓库压缩包名称
BKUP_REPO_LOCAL=$3    #备份仓库本地目录
PREDIR=$(pwd)

if [ -x "$BKUP_REPO_COMPRESS" ]; then                #对应的备份仓库压缩文件存在
    tar zxvf $BKUP_REPO_COMPRESS -C $BKUP_REPO_LOCAL #解压备份仓库
fi
if [ -x "$BKUP_REPO_LOCAL/.git" ]; then            #备份仓库git目录存在
    ../backup.sh $MAIN_REPO_LOCAL $BKUP_REPO_LOCAL #执行备份操作
else                                               #备份仓库git目录不存在
    rm -rf $BKUP_REPO_LOCAL                        #删除备份仓库
    cp $MAIN_REPO_LOCAL $BKUP_REPO_LOCAL           #直接移动
fi
cd $BKUP_REPO_LOCAL
tar -zcvf $BKUP_REPO_COMPRESS ./.git #打压缩包

cd $PREDIR
