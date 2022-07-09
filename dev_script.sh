#!/bin/sh

export DOCKER_USER=$1
export DOCKER_PASSWORD=$2

uptime
echo $DOCKER_PASSWORD | docker login -u="DOCKER_USER" --password-stdin

