#!/bin/bash

export IMAGE=$1
export DOCKER_USR=$2
export DOCKER_PWD=$3
export IMAGE=$4
echo $DOCKER_PWD | docker login -u $DOCKER_USR --password-stdin
docker run -d $IMAGE && echo "COntainer was started"