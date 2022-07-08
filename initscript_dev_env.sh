#!/usr/bin/env bash

export BUILD_TIMESTAMP=$1
export DOCKERHUB_USR=$2
export DOCKERHUB_PWD=$3

whoami
# curl http://checkip.amazonaws.com
# echo $DOCKERHUB_PWD | docker login -u $DOCKERHUB_USR --password-stdin
# docker run -p 8080:8080 -d alexego/final_task:final_task_${BUILD_TIMESTAMP} && echo "COntainer was started"