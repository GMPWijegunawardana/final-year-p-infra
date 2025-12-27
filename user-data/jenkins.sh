#!/bin/bash
set -e

apt update -y

# Java
apt install -y openjdk-17-jdk

# Jenkins
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

apt update -y
apt install -y jenkins

systemctl enable jenkins
systemctl start jenkins

# Docker
apt install -y docker.io
usermod -aG docker ubuntu
usermod -aG docker jenkins
systemctl enable docker
systemctl start docker

# SonarQube
docker run -d --name sonarqube \
  -p 9000:9000 sonarqube:lts

# Trivy
wget https://github.com/aquasecurity/trivy/releases/latest/download/trivy_0.50.0_Linux-64bit.deb
dpkg -i trivy_0.50.0_Linux-64bit.deb
