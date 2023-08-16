#!/bin/bash

ip=`ip route get 8.8.8.8 | awk -F"src " 'NR==1{split($2,a," ");print a[1]}'`

export NEEDRESTART_SUSPEND=1
echo -e "\n---------------HALTDOS PROFESSIONAL WAF SETUP---------------"

echo "Updating Sources List"
echo -e 'deb [trusted=yes] https://repo.haltdos.com/apt/ /' | sudo tee /etc/apt/sources.list.d/haltdos.list &> /var/log/setup.log
apt-get update &> /var/log/setup.log

echo "Installing Haltdos Professional WAF"
if [ "$(dpkg -l | awk '/haltdos-pro-waf/ {print }'|wc -l)" -ge 1 ]; then
    echo "Haltdos Professional WAF already installed"
else
    apt-get install -y  haltdos-pro-waf &> /var/log/setup.log
fi

echo "Installing Haltdos Professional GUI"
if [ "$(dpkg -l | awk '/haltdos-pro-gui/ {print }'|wc -l)" -ge 1 ]; then
    echo "Haltdos Professional GUI already installed"
else
    apt-get install -y  haltdos-pro-gui &> /var/log/setup.log
fi

echo -e "Access Haltdos Professional WAF at https://$ip:9000\n"
export NEEDRESTART_SUSPEND=0
rm setup.sh