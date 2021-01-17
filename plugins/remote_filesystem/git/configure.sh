#!/bin/bash

#配置相关文件

PERFIX=$1
CONF_PATH=$(dirname ${BASH_SOURCE[0]})
echo $PERFIX > "$CONF_PATH/PERFIX"