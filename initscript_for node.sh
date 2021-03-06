#!/bin/bash
# - Remote FS root: /var/jenkins
echo "******** swap file ******** "
sudo dd if=/dev/zero of=/swapfile bs=128M count=16
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

echo "******** install docker, git, maven, java, gradle ******** "
sudo yum update -y
sudo yum install -y \
  yum-utils \
  git \
  docker \
  maven \
  java-openjdk11 \
  gradle
echo "******** install docker and git ******** "
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform

echo "******** start docker service ******** "
sudo service docker start
echo "******** usermod ******** "
sudo usermod -a -G docker ec2-user
echo "******** chkconfig ******** "
sudo chkconfig docker on

echo "******** change docker.sock permissions ******** "
sudo chmod 666 /var/run/docker.sock

echo "******** Creating Jenkins Workspace********"
sudo mkdir -p /var/jenkins
sudo chown -R ec2-user:ec2-user /var/jenkins
sudo chmod -R 770 /var/jenkins
echo "******** Creating Jenkins Workspace********"
while [[ -z $(/sbin/service docker status | grep " is running...") &&  $sleep_counter -lt 20 ]]; do sleep 1; ((sleep_counter++)); echo "Waiting for docker $sleep_counter seconds - $(/sbin/service docker status)"; done
whoami






echo "******** newgrp to do not restart ******** "
exec sudo su -l $USER
exec newgrp docker 




#!/bin/bash
# - Remote FS root: /var/jenkins
echo "******** Set up repo ******** "
sudo yum update
sudo yum install -y yum-utils
sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/rhel/docker-ce.repo

echo "******** install docker ******** "
sudo yum install -y \
  git \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-compose-plugin

echo "******** configure docker ******** "
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker 

echo "******** start docker ******** "
sudo systemctl start docker


# AMI: ami-f95ef58a (Standard Ubuntu 14.04)


sudo apt-get update -y

echo "--> Installing Docker, Python, Java, Git, pv"
sudo apt-get -y update
sudo apt-get install -y \
    linux-image-extra-$(uname -r) \
    docker-engine \
    openjdk-7-jdk \
    git \
    python3 \
    python3-dev \
    pv

echo "--> Adding user to Docker group"
sudo groupadd docker
sudo usermod -aG docker ubuntu

echo "--> Installing pip, invoke, docker-py, invoke-docker-flow"
sudo curl -O https://bootstrap.pypa.io/get-pip.py
sudo python3 get-pip.py
sudo pip install \
    invoke \
    docker-py \
    invoke-docker-flow

echo "--> Starting Docker"
sudo service docker start

echo ""
echo "--> Creating Jenkins Workspace"
echo ""
sudo mkdir -p /var/jenkins
sudo chown -R ubuntu:ubuntu /var/jenkins
sudo chmod -R 770 /var/jenkins

echo ""
echo "--> Done!"
echo ""



sudo apt update 
sudo apt install git -y
sudo apt install openjdk-8-jre-headless -y
sudo apt-get update
sudo apt-get install -y \
ca-certificates \
curl \
gnupg \
lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
useradd jenkins --create-home --shell /bin/bash --groups docker
sudo chmod 666 /var/run/docker.sock
sudo usermod -a -G docker $USER
sudo service docker start
