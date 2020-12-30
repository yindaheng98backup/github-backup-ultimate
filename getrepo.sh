#!/bin/bash

#此脚本用于下载远程仓库
URL=$1 #仓库地址
DIR=$2 #仓库目录
PRE=$(pwd)
rm -rf $DIR
mkdir $DIR
git clone --mirror $URL $DIR/.git #下载仓库中的所有branch
cd $DIR
git config --bool core.bare false
cd $PRE
