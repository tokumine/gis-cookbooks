#!/bin/sh
set -e -x
# Chef-solo bootstrap script for Ubuntu Lucid 10.04 (ami-714ba518)
# S. Tokumine 2010
#
# Run from the command line using the AWS EC2 API tools like:
# (assumes a working EC2 tools install - EC2_PRIVATE_KEY and EC2_CERT are set)
#
# Base explanation
# ec2-run-instances ami-714ba518 -f THIS_FILE
# 
# Example of a 50GB EBS server with keypair and member of default and ppeutility security groups
# ec2-run-instances --block-device-mapping /dev/sda1=:50 ami-714ba518 -f boot.sh -k ppekey -g default -g ppeutility

# resize disk to the size set in init line (see comments above)
resize2fs /dev/sda1



# Add Brightbox APT repository
wget http://apt.brightbox.net/release.asc -O - | sudo apt-key add -

# Add brightbox REE to sources
echo 'deb http://apt.brightbox.net/ lucid rubyee' > /etc/apt/sources.list.d/brightbox-rubyee.list

# update apt
apt-get update
#apt-get -y --force-yes upgrade # <--- not working due to some upgrades needing console input...

# install basic prerequisite packages
apt-get -y install htop build-essential wget ssl-cert git-core xfsprogs libreadline5-dev checkinstall libruby1.8 ruby ruby1.8-dev libopenssl-ruby1.8 rdoc ri irb 

# compile rubygems from source
cd /tmp
wget http://production.cf.rubygems.org/rubygems/rubygems-1.3.6.tgz
tar zxvf rubygems-1.3.6.tgz
cd /tmp/rubygems-1.3.6
ruby setup.rb
ln -sfv /usr/bin/gem1.8 /usr/bin/gem

# install check and ohai
gem sources -a http://gems.opscode.com
gem install ohai chef --no-rdoc --no-ri

# clone tokumine chef repo
cd /tmp
git clone http://github.com/tokumine/gis-cookbooks.git
cd /tmp/gis-cookbooks

# kick off various different server configs depending on the server
# replace .json with the type of server you want to make
#
# database.json 		- configure as a postGIS 1.5.1 box
# web.json					- configure as a nginx+REE box
# utility.json			- configure sphinx and memcached
# starspan.json			- configure starspan
# loadbalancer.json	- TBD
#
/usr/bin/chef-solo -c config/solo.rb -j server/database.json >> /var/log/chef.log