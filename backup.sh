#!/bin/bash

# 此脚本将主仓库分支按指定规则合并到备份仓库的分支中

MAIN_REPO=$1 #主仓库目录
BKUP_REPO=$2 #备份仓库目录

git --git-dir="$BKUP_REPO/.git" remote add main $MAIN_REPO          #添加主仓库作为备份仓库的远程仓库
git --git-dir="$BKUP_REPO/.git" --work-tree="$BKUP_REPO" fetch main #将主仓库的内容获取到备份仓库
cd $BKUP_REPO

#主仓库branch:ref列表
echo "主仓库："
declare -a branch_dict_main=()
for branch in $(git branch --remote --format='%(refname:short)'); do
    branch_name=${branch/"main/"/''}
    branch_dict_main+=(["$branch_name"]="$branch")
done
#输出主仓库分支列表以便帮助排查错误
for branch_name in ${!branch_dict_main[@]}; do
    ref=${branch_dict_main["$branch_name"]}
    echo -e "$branch_name\t$branch"
done
#备份仓库branch列表
echo "备份仓库："
declare -a branch_list_bkup=()
for branch in $(git branch --format='%(refname:short)'); do
    branch_list_bkup+=("$branch")
done
#输出备份仓库分支列表以便帮助排查错误
for branch in ${branch_list_bkup[@]}; do
    echo "$branch"
done

cd ..

function pack_repo() {
    #TODO: 1. 将上面那个函数操作完成的备份仓库打个压缩包
    #TODO: 2. 将所有备份仓库的压缩包再集中到一个另外的仓库中
    #TODO: 3. 放压缩包的仓库不需要留历史记录，因此每次都是通过git init生成以节约空间
}
