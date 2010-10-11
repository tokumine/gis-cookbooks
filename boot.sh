#!/bin/sh
set -e -x
# Chef-solo bootstrap script for Ubuntu Lucid 10.04 (ami-714ba518)
# S. Tokumine 2010
#
# Run using the AWS EC2 API tools:
#  
# ec2-run-instances --block-device-mapping /dev/sda1=:150 ami-6006f309 -f boot.sh -k ppekey -g default -g ppeutility -z us-east-1a -m -t m2.xlarge
# (50gb EBS server. Assumes EC2_PRIVATE_KEY and EC2_CERT are set)
#
# 32bit box: ami-6c06f305
# 64bit box: ami-6006f309
#
# in ppe production, we run:
#
# DB:   m2.xlarge/ami-6006f309/150GB
# WEB:  m2.xlarge/ami-6006f309/80GB  #<-- this will change in the future!
# UTIL: c1.medium/ami-6c06f305/80GB
#
# resize EBS
resize2fs /dev/sda1

# Brightbox APT repository
wget http://apt.brightbox.net/release.asc -O - | sudo apt-key add -

# brightbox REE to sources
echo 'deb http://apt.brightbox.net/ lucid rubyee' > /etc/apt/sources.list.d/brightbox-rubyee.list

# update apt
aptitude -y update
#aptitude -y safe-upgrade

# install basic packages
apt-get -y install htop build-essential wget ssl-cert git-core xfsprogs libreadline5-dev checkinstall libruby1.8 ruby ruby1.8-dev libopenssl-ruby1.8 rdoc ri irb

# compile rubygems from source
cd /tmp
wget http://production.cf.rubygems.org/rubygems/rubygems-1.3.6.tgz
tar zxvf rubygems-1.3.6.tgz
cd /tmp/rubygems-1.3.6
ruby setup.rb
ln -sfv /usr/bin/gem1.8 /usr/bin/gem

# install chef
gem sources -a http://gems.opscode.com
gem install ohai --version "0.5.4" --no-rdoc --no-ri
gem install chef --version "0.8.16" --no-rdoc --no-ri
  
# clone tokumine chef repo
cd /tmp
git clone http://github.com/tokumine/gis-cookbooks.git
cd /tmp/gis-cookbooks

# kick off various different server configs depending on the server
# replace .json with the type of server you want to make
#
# database.json 		- configure as a postGIS 1.4 box
# web.json					- configure as a nginx+REE box
# utility.json			- configure sphinx
# starspan.json			- configure starspan
# full_stack.json   - database.json + web.json + utility.json
#
/usr/bin/chef-solo -c config/solo.rb -j server/database.json >> /var/log/chef.log