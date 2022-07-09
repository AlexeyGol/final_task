#!/bin/sh

export DOCKER_USER=$1
export DOCKER_PASSWORD=$2

echo $DOCKER_USER
docker login -u="$DOCKER_USER" -p="$DOCKER_PASSWORD"

