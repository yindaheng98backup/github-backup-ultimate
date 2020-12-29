#!/bin/bash

# 此脚本将主仓库分支按指定规则合并到备份仓库的分支中

MAIN_REPO=$1 #主仓库目录
BKUP_REPO=$2 #备份仓库目录

git --git-dir="$BKUP_REPO/.git" remote add main $MAIN_REPO          #添加主仓库作为备份仓库的远程仓库
git --git-dir="$BKUP_REPO/.git" --work-tree="$BKUP_REPO" fetch main #将主仓库的内容获取到备份仓库
cd $BKUP_REPO

#获取分支列表
function get_branch_dict() {
    declare -a refs_list
    refs_root=$1
    eval $(git for-each-ref --shell --format='refs_list+=(%(refname))' $refs_root)
    for ref in ${refs_list[@]}; do #计算主仓库branch:ref
        branch_name=${ref/"$refs_root"/''}
        branch_dict_name=$2
        echo "$branch_dict_name+=(['$branch_name']='$ref')"
    done
}
declare -A branch_dict_main #主仓库branch:ref列表
declare -A branch_dict_bkup #备份仓库branch:ref列表
eval $(get_branch_dict 'refs/heads/' 'branch_dict_bkup')
eval $(get_branch_dict 'refs/remotes/main/' 'branch_dict_main')

#输出主仓库分支列表以便帮助排查错误
echo "主仓库："
for branch in ${!branch_dict_main[@]}; do
    ref=${branch_dict_main["$branch"]}
    echo -e "$branch\t$ref"
done
#输出备份仓库分支列表以便帮助排查错误
echo "备份仓库："
for branch in ${!branch_dict_bkup[@]}; do
    ref=${branch_dict_bkup["$branch"]}
    echo -e "$branch\t$ref"
done

cd ..
rm -rf $MAIN_REPO
rm -rf $BKUP_REPO

function pack_repo() {
    #TODO: 1. 将上面那个函数操作完成的备份仓库打个压缩包
    #TODO: 2. 将所有备份仓库的压缩包再集中到一个另外的仓库中
    #TODO: 3. 放压缩包的仓库不需要留历史记录，因此每次都是通过git init生成以节约空间
}
