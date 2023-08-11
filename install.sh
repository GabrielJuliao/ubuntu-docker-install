#!/bin/bash
printf "Script created by Gabriel Juliao. \nSee more on: https://github.com/GabrielJuliao \n\n"

# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

echo "Uninstalling old versions of Docker, if any."
apt-get remove docker docker-engine docker.io containerd runc
echo
apt-get update
echo Setting up the repository, and downloading the dependencies...
apt-get install -y \
  ca-certificates \
  curl \
  gnupg \
  lsb-release

echo Adding Docker’s official GPG key...
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list >/dev/null
apt-get update
echo Installing Docker Engine and CLI components...
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
echo Starting Docker service....
service docker start

sec=30
while [ $sec -ge 0 ]; do
  echo -ne "  Waiting... ${sec}s\033[0K\r"
  let "sec=sec-1"
  sleep 1
done

echo Running sample container... You should see Hello World from docker.
groupadd docker
usermod -aG docker $USER
docker run hello-world
echo DONE!

printf "Run the command: 'newgrp docker' as a normal user (aka no sudo/root)\n"