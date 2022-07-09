#!/bin/sh

export DH_USR=$1
export DH_PWD=$2

# echo $DH_PWD | docker login -u $DH_USR --password-stdin
uptime
docker ps