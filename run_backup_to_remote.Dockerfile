FROM ubuntu:focal

ARG USER=$1
ARG GH_TOKEN=$2
ARG REPO_PLUGINS=$3
COPY . .
RUN apt-get update && apt-get install -y git jq wget curl && \
    ./run_backup_to_remote.sh $USER $GH_TOKEN "$REPO_PLUGINS"

