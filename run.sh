#!/bin/bash
GH_TOKEN=$4

PACKREPO_URL=$2
PACKREPO_BRANCH=$3
rm -rf ./.git
rm -rf ./backup
git clone -b $PACKREPO_BRANCH $PACKREPO_URL ./backup
cd ./backup
rm -rf .git

function backup_repo() {
    URL=$1
    echo "开始备份"$URL
    CLONE_URL=$(eval "echo $url | sed 's/https:\/\/github.com/https:\/\/$GH_TOKEN@github.com/g'")
    REPO_NAME=$(eval "echo $url | sed 's/.*'$USER'\/\(.*\).git$/\1/g'")
    if [ -x "$REPO_NAME.tar.gz"]; then
        tar zxvf $REPO_NAME.tar.gz -C ./main
        ./getrepo.sh $CLONE_URL ./bkup
        ./backup.sh ./main ./bkup
        rm -rf ./main
    fi
    tar -zcvf ./$REPO_NAME.tar.gz ./bkup/.git
    rm -rf ./bkup
}

USER=$1
REPOS_URL=https://api.github.com/users/$USER/repos?access_token="$GH_TOKEN"
curl -s $REPOS_URL | jq -c '.[].clone_url' | while read url; do
    backup_repo $url
done

git config user.name "TravisCI"
git config user.email "yindaheng98@163.com"
set -e
git init
git add -A
git commit -m 'TravisCI Backup'
set -e
git push -u $PACKREPO_URL HEAD:$PACKREPO_BRANCH --force