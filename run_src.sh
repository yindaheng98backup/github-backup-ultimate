#!/bin/bash

SRC_REPO=$1
SRC_BRANCH=$2
BKP_REPO=$3
BKP_BRANCH=$4
git clone -b $SRC_BRANCH $SRC_REPO ./src
git clone -b $BKP_BRANCH $BKP_REPO ./bkp
cd ./bkp
git remote add src ../src
git fetch src
git branch -a
git checkout src/$SRC_BRANCH
git branch -d $BKP_BRANCH
git checkout -b $BKP_BRANCH
git push --set-upstream origin $BKP_BRANCH --force
cd ..
rm -rf ./src
rm -rf ./bkp