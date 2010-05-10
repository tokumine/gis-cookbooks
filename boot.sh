#!/bin/sh
# S. Tokumine 2010
# Chef-solo bootstrap script for Ubuntu Lucid 10.04 (ami-714ba518)
#
# Run from the command line using the AWS EC2 API tools like:
# ec2-run-instances --block-device-mapping /dev/sda1=:100 ami-714ba518 -f THIS_FILE
#
# (assumes a working EC2 tools install - EC2_PRIVATE_KEY and EC2_CERT are set)

set -e -x

# update apt
apt-get update
#apt-get -y --force-yes upgrade

# install basic prerequisite packages
apt-get -y install htop build-essential wget ssl-cert git-core xfsprogs libreadline5-dev
# USING REE NOW. ruby ruby1.8-dev libopenssl-ruby1.8 rdoc ri irb

# install REE and configure as the base Ruby interpreter
cd /tmp

# 32-bit AMI's
wget http://rubyforge.org/frs/download.php/68718/ruby-enterprise_1.8.7-2010.01_i386.deb
dpkg -i ruby-enterprise_1.8.7-2010.01_i386.deb

# # 64-bit AMI's
# wget http://rubyforge.org/frs/download.php/68720/ruby-enterprise_1.8.7-2010.01_amd64.deb
# dpkg -i ruby-enterprise_1.8.7-2010.01_amd64.deb

# reload environment to start using REE after install
source /etc/environment


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
/usr/bin/chef-solo -c config/solo.rb -j server/starspan.json >> /var/log/chef.log