#!/usr/bin/bash

export IMAGE=$1
export DOCKERHUB_USR=$2
export DOCKERHUB_PWD=$3

whoami
curl http://checkip.amazonaws.com
echo $DOCKERHUB_PWD | docker login -u $DOCKERHUB_USR --password-stdin
docker run -p 8080:8080 -d $IMAGE && echo "COntainer was started"