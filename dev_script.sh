#!/bin/sh

export DOCKER_USER=$1
export DOCKER_PASSWORD=$2
export DOCKER_IMAGE=$3

uptime
echo $DOCKER_PASSWORD | docker login -u $DOCKER_USER --password-stdin
DOCKER_IMAGE=$DOCKER_IMAGE docker-compose up -d
docker image prune -af




