#!/bin/sh

export DOCKER_USER=$1
export DOCKER_PASSWORD=$2

echo $DOCKER_USER
docker login -u alexego -p $(echo $DOCKER_PASSWORD)

