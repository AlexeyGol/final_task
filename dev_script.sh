#!/bin/sh

export DOCKER_USER=$1
export DOCKER_PASSWORD=$2

echo $DOCKER_PASSWORD | docker login -u=alexego -password-stdin

