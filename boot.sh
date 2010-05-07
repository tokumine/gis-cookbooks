#!/bin/sh
# Chef scripts for Ubuntu Lucid 10.04 
set -e -x

# update apt
apt-get update
#apt-get -y --force-yes upgrade

# install basic prerequisite packages
apt-get -y install htop ruby ruby1.8-dev libopenssl-ruby1.8 rdoc ri irb build-essential wget ssl-cert git-core xfsprogs 

# compile rubygems from source
cd /tmp
wget http://production.cf.rubygems.org/rubygems/rubygems-1.3.6.tgz
tar zxvf rubygems-1.3.6.tgz
cd rubygems-1.3.6
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
/usr/bin/chef-solo -c config/solo.rb -j server/starspan.json > /var/log/chef.log