#!/bin/sh

export DOCKER_USER=$1
export DOCKER_PASSWORD=$2
export DOCKER_IMAGE=$3

uptime
echo $DOCKER_PASSWORD | docker login -u $DOCKER_USER --password-stdin
docker pull $DOCKER_IMAGE
docker stop petclinic
docker run -p 8080:8080 -d --name petclinic $DOCKER_IMAGE 
docker rmi $(docker images -aq)