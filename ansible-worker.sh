#!/bin/bash
# Hardware requirements: AWS Linux 2 with mimum t2.micro type instance & port 8080(application port), 9100 (node-exporter port) should be allowed on the security groups
sudo yum update -y
sudo useradd ansadmin
sudo passwd ansadmin
sudo echo ansadmin:ansadmin | chpasswd
sudo sed -i "s/.*PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
sudo service sshd restart
sudo echo "%wheel  ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers
sudo service sshd restart
sudo usermod -aG wheel ansadmin

#for amazon linux 2
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

# node-exporter installations
sudo useradd --no-create-home node_exporter

wget https://github.com/prometheus/node_exporter/releases/download/v1.0.1/node_exporter-1.0.1.linux-amd64.tar.gz
tar xzf node_exporter-1.0.1.linux-amd64.tar.gz
sudo cp node_exporter-1.0.1.linux-amd64/node_exporter /usr/local/bin/node_exporter
rm -rf node_exporter-1.0.1.linux-amd64.tar.gz node_exporter-1.0.1.linux-amd64

# setup the node-exporter dependencies
sudo yum install git -y
sudo git clone -b installations https://github.com/cvamsikrishna11/devops-fully-automated.git /tmp/devops-fully-automated
sudo cp /tmp/devops-fully-automated/prometheus-setup-dependencies/node-exporter.service /etc/systemd/system/node-exporter.service

sudo systemctl daemon-reload
sudo systemctl enable node-exporter
sudo systemctl start node-exporter
sudo systemctl status node-exporter

