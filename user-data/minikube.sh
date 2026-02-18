#!/bin/bash
set -e

# Update system
apt update -y
apt upgrade -y

# Install required utilities
apt install -y curl wget apt-transport-https ca-certificates conntrack


# Install Docker

apt install -y docker.io
systemctl enable docker
systemctl start docker

usermod -aG docker ubuntu


# Install kubectl

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
mv kubectl /usr/local/bin/


# Install Minikube

curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
install minikube-linux-amd64 /usr/local/bin/minikube


# Start Minikube

sudo -u ubuntu minikube start --driver=docker --force


# Install Argo CD

sudo -u ubuntu kubectl create namespace argocd || true

sudo -u ubuntu kubectl apply -n argocd -f \
https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml


# Expose Argo CD Server as NodePort

sudo -u ubuntu kubectl patch svc argocd-server -n argocd \
  -p '{"spec": {"type": "NodePort"}}'
