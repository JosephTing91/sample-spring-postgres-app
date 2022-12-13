#!/bin/sh

#for amazon linux 2
sudo yum update -y
sudo yum install docker-engine -y

#Add group membership for the default ec2-user so you can run all docker commands without using the sudo command:
sudo usermod -a -G docker ansadmin
id ansadmin
# Reload a Linux user's group assignments to docker w/o logout
newgrp docker

#docker compose
sudo yum install python3-pip
# 2. Then run any one of the following
sudo pip3 install docker-compose # with root access update this to change to ansadmin user...

#enable docker service at boot
sudo systemctl enable docker.service
sudo systemctl start docker.service

#important note!!! append the following path to PATH env variable /usr/local/bin


