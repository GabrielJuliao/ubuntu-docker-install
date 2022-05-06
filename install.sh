#!/bin/bash
printf "WSL Docker Install v0.1\nNote: this script was only tested in Ubuntu 20.04.4LTS for WSL\n"
# Init
FILE="/tmp/out.$$"
GREP="/bin/grep"
#....
# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

printf "Script created by Gabriel Juliao. \nSee more on: https://github.com/GabrielJuliao \n\n"

#DNS CONFIGURATION INIT-----------------------------------------------------------------------

#resolv.conf attr
echo "Starting DNS configuration..."

VAR_I=$(sudo lsattr /etc/resolv.conf)
EXPECTED_VAR_I="----i---------e----- /etc/resolv.conf"

if [[ "$VAR_I" == "$EXPECTED_VAR_I" ]]; then
  echo "Your resolv.conf is immutable, removing atribute..."
  sudo chattr -i /etc/resolv.conf
  printf "Done! \n\n"
fi

#DNS
DNS_CONFIG=$(cat /etc/resolv.conf)
EXPECTED_DNS_CONFIG="nameserver 1.1.1.1"

sudo rm /etc/resolv.conf
sudo bash -c 'echo "nameserver 1.1.1.1" > /etc/resolv.conf'
sudo chattr +i /etc/resolv.conf

if [[ "$DNS_CONFIG" == "$EXPECTED_DNS_CONFIG" ]]; then
  printf "Your DNS has been successfully configured with the following configuration:\n" 
  echo $(cat /etc/resolv.conf)
  echo 
else
  echo "Could not configure your DNS, if you are having trouble fetching updates from ubuntu servers, try configuring it manually."
fi

#wsl.conf
WSL_CONF=$(cat /etc/wsl.conf)
EXPECTED_WSL_CONF="[network] generateResolvConf = false"

echo "Disabling WSL generateResolvConf..."
sudo bash -c 'echo "[network]" > /etc/wsl.conf'
sudo bash -c 'echo "generateResolvConf = false" >> /etc/wsl.conf'
echo Current: $WSL_CONF
echo Expected: $EXPECTED_WSL_CONF
echo

#DNS CONFIGURATION END-----------------------------------------------------------------------
