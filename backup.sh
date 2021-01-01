#!/bin/bash

# 此脚本将主仓库分支按指定规则合并到备份仓库的分支中

MAIN_REPO=$1 #主仓库目录
BKUP_REPO=$2 #备份仓库目录

git --git-dir="$BKUP_REPO/.git" remote add main $MAIN_REPO          #添加主仓库作为备份仓库的远程仓库
git --git-dir="$BKUP_REPO/.git" --work-tree="$BKUP_REPO" fetch main #将主仓库的内容获取到备份仓库
cd $BKUP_REPO

#主仓库branch:ref列表
echo "主仓库："
unset branch_dict_main
declare -A branch_dict_main=()
for branch in $(git branch --remote --format='%(refname:short)'); do
    branch_name=${branch/"main/"/''}
    branch_dict_main+=(["$branch_name"]="$branch")
done
#输出主仓库分支列表以便帮助排查错误
for branch_name in ${!branch_dict_main[@]}; do
    branch=${branch_dict_main["$branch_name"]}
    echo -e "$branch_name\t$branch"
done
#备份仓库branch列表
echo "备份仓库："
unset branch_list_bkup
declare -a branch_list_bkup=()
for branch in $(git branch --format='%(refname:short)'); do
    branch_list_bkup+=("$branch")
done
#输出备份仓库分支列表以便帮助排查错误
for branch in ${branch_list_bkup[@]}; do
    echo "$branch"
done

#1. 比对主仓库和备份仓库的branch结构
for branch in ${!branch_dict_main[@]}; do
    echo "检查'$branch'分支"
    branch_in_main=${branch_dict_main["$branch"]}
    branch_in_bkup=$branch

    if [[ ! " ${branch_list_bkup[@]} " =~ " $branch " ]]; then
        #2. 如果主仓库中有备份仓库中没有的branch，则创建branch
        echo "备份仓库中缺少'$branch'分支，需要添加"
        git checkout $branch_in_main
        git checkout -b $branch
        continue
    fi

    #3. 如果主仓库中有与备份仓库中同名的branch，则进一步比对
    echo "备份仓库中有'$branch'分支"
    if [ -z "$(git diff $branch_in_main $branch_in_bkup)" ]; then
        #3-1. 如果同名的branch中的commit记录完全一致，则不进行操作
        echo "主仓库和备份仓库中的'$branch'分支没有diff，无需修改"
        continue
    fi
    if [ -z "$(git diff $branch_in_bkup...$branch_in_main)" ]; then
        #3-2. 如果同名的branch中的commit记录不是上述两种情况，则将备份仓库中的branch重命名为“时间+branch名”，而用主仓库中的branch覆盖原branch
        echo "主仓库中的'$branch'分支不是备份仓库的 fast forward，需要先将备份仓库中的'$branch'分支重命名"
        branch_rename=$branch"."$(date '+%Y%m%d%H%M%S')
        echo "备份仓库的'$branch'分支重命名为'$branch_rename'"
        git checkout $branch_in_bkup   #切换到备份仓库的$branch分支
        git checkout -b $branch_rename #重命名备份仓库的$branch分支
    else
        #3-3. 如果同名的branch中主仓库的commit记录只比备份仓库的commit记录多最后几个，前面都是完全一直，则直接用主仓库中的branch覆盖之
        echo "主仓库中的'$branch'分支是备份仓库的 fast forward，可以直接覆盖"
    fi
    echo "用主仓库的'$branch'分支覆盖备份仓库的'$branch'分支"
    git checkout $branch_in_main  #切换到主仓库的$branch分支
    git branch -D $branch_in_bkup #删除备份仓库的$branch分支
    git checkout -b $branch       #将主仓库的$branch分支变成备份仓库的$branch分支
done
git branch
cd ..
git --git-dir="$BKUP_REPO/.git" remote remove main #删除用完了的远程仓库
