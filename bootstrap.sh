#!/bin/bash

mkdir -p ~/bootstrap
cd ~/bootstrap
wget http://apt.puppetlabs.com/puppetlabs-release-precise.deb
sudo dpkg -i puppetlabs-release-precise.deb
sudo apt-get update
sudo apt-get install -y puppet git
git clone git@github.com:*****
cd *****
git submodule init
git submodule update
cd ..
sudo rm -rf /etc/puppet
sudo mv ~/bootstrap/***** /etc/puppet
rm -rf ~/bootstrap/
cd /etc/puppet
sudo puppet apply --verbose manifests/site.pp
