#!/bin/bash
set -e

# Update system
apt update -y
apt upgrade -y

# Install basic utilities
apt install -y curl wget unzip git apt-transport-https ca-certificates gnupg lsb-release software-properties-common


# Install Java (Required for Jenkins)
apt install -y openjdk-17-jdk

# Install Jenkins

curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

apt update -y
apt install -y jenkins

systemctl enable jenkins
systemctl start jenkins


# Install Docker

apt install -y docker.io
systemctl enable docker
systemctl start docker

usermod -aG docker ubuntu
usermod -aG docker jenkins


# Install NodeJS (For MERN build)

curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt install -y nodejs


# Install Trivy

wget https://github.com/aquasecurity/trivy/releases/latest/download/trivy_0.50.0_Linux-64bit.deb
dpkg -i trivy_0.50.0_Linux-64bit.deb


# Install OWASP Dependency Check (CLI)

wget https://github.com/jeremylong/DependencyCheck/releases/latest/download/dependency-check-8.4.0-release.zip
unzip dependency-check-8.4.0-release.zip
mv dependency-check /opt/


# Run SonarQube as Docker container

docker run -d \
  --name sonarqube \
  -p 9000:9000 \
  sonarqube:lts

# Restart Jenkins to apply Docker group

systemctl restart jenkins
