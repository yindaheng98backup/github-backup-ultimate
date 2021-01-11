FROM ubuntu:focal

ARG GH_TOKEN=$1
ARG PLUGIN_PATH=$2
ARG accessKeyID=$3
ARG accessKeySecret=$4
ARG endpoint=$5
ARG backupPath=$6
ARG DAYS_AGO=$7
COPY . .
RUN apt-get update && apt-get install -y git jq wget curl && \
    $PLUGIN_PATH/configure.sh $accessKeyID $accessKeySecret $endpoint $backupPath && \
    ./run_backup_to_tar.gz.sh $GH_TOKEN $PLUGIN_PATH $DAYS_AGO