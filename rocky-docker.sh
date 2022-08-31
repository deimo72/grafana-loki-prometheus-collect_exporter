#!/usr/bin/env bash 

# Fuente: https://gist.github.com/ryanmaclean/91b270d858939729443f889760b4d72f
## Script to install docker-ce on Rocky Linux
## Run using `sudo rocky-docker.sh`

# Ensuring "GROUP" variable has not been set elsewhere
unset GROUP

echo "Removing podman and installing Docker CE"
dnf remove -y podman buildah
dnf install -y yum-utils
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
dnf install -y docker-ce docker-ce-cli containerd.io --allowerasing

echo "Setting up docker service"
systemctl enable docker
systemctl start docker
#systemctl status docker

echo "Adding permissions to current user for docker, attempting to reload group membership"
usermod -aG docker -a $USER
GROUP=$(id -g)
newgrp docker
newgrp $GROUP
unset GROUP

echo "Install completed, though you will probably require logout/login if the following command fails:"
docker ps



# Docker Compose
compose_release() {
  curl --silent "https://api.github.com/repos/docker/compose/releases/latest" |
  grep -Po '"tag_name": "\K.*?(?=")'
}

if ! [ -x "$(command -v docker-compose)" ]; then
  curl -L https://github.com/docker/compose/releases/download/$(compose_release)/docker-compose-$(uname -s)-$(uname -m) \
  -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose
fi

echo "Install Docker Compose"
docker-compose --version

