#!/bin/sh

export DOCKER_USER=$1
export DOCKER_PASSWORD=$2
export DOCKER_IMAGE=$3

uptime
echo $DOCKER_PASSWORD | docker login -u $DOCKER_USER --password-stdin
DOCKER_IMAGE=$DOCKER_IMAGE docker-compose up -d





# docker pull $DOCKER_IMAGE
# docker stop petclinic
# docker rm petclinic
# docker run -p 8080:8080 -d --name petclinic $DOCKER_IMAGE 
# docker container prune -f
# docker image prune -af