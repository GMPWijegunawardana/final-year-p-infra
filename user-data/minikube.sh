#!/bin/bash
set -e

apt update -y

# Docker
apt install -y docker.io
usermod -aG docker ubuntu
systemctl enable docker
systemctl start docker

# kubectl
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s \
https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x kubectl
mv kubectl /usr/local/bin/

# Minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
install minikube-linux-amd64 /usr/local/bin/minikube

sudo -u ubuntu minikube start --driver=docker
