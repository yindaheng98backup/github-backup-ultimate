function backup_branch() {
    BRANCH=$1
    git diff 
}

function backup_repo() {
    REPO=$1
    git remote add -f backup $REPO
    git remote update
    git branch
}

function merge_repo() {
    SRC_REPO_DIR=$1 #主仓库
    DST_REPO_DIR=$2 #备份仓库
    # 将主仓库分支按指定规则合并到备份仓库的分支中
    cd DST_REPO_DIR #切换到备份仓库
    git remote add other ../$SRC_REPO_DIR #添加主仓库作为备份仓库的远程仓库
    git fetch other #将主仓库的内容获取到备份仓库
    #TODO: 1. 比对主仓库(即other)和备份仓库(即DST_REPO_DIR)的branch结构
    #TODO: 2. 如果主仓库中有备份仓库中没有的branch，则创建branch
    #TODO: 3. 如果主仓库中有与备份仓库中同名的branch，则进一步比对：
    #TODO:     * 如果同名的branch中的commit记录完全一致，则不进行操作
    #TODO:     * 如果同名的branch中主仓库的commit记录只比备份仓库的commit记录多最后几个，前面都是完全一直，则直接用主仓库中的branch覆盖之
    #TODO:     * 如果同名的branch中的commit记录不是上述两种情况，则将备份仓库中的branch重命名为“时间+branch名”，而用主仓库中的branch覆盖原branch
    #TODO: 4. push备份仓库
    git checkout -b repo2 other/master
    cd ..
}

function pack_repo() {
    #TODO: 1. 将上面那个函数操作完成的备份仓库打个压缩包
    #TODO: 2. 将所有备份仓库的压缩包再集中到一个另外的仓库中
    #TODO: 3. 放压缩包的仓库不需要留历史记录，因此每次都是通过git init生成以节约空间
}
