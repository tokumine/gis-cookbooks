#
# Cookbook Name:: postgis
# Recipe:: default
#
# Copyright 2010, ProtectedPlanet.net
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
include_recipe 'gdal'
include_recipe 'geos'
include_recipe 'proj'
include_recipe 'postgres'

remote_file "download postgis" do
  path "/tmp/postgis.tar.gz"
  source "http://postgis.refractions.net/download/postgis-#{node[:postgis][:version]}.tar.gz"
end
 
 # remove with dpkg -r starspan
bash "install postgis" do
  user "root"
  cwd "/tmp"
  code <<-EOH    
  tar zxvf postgis.tar.gz
  cd postgis*
  ./configure
  make
  checkinstall --pkgname postgis-src --pkgversion #{node[:postgis][:version]}-src --default 
  EOH
  returns 2
  not_if { File.exists? "/tmp/postgis.tar.gz"}
end

service "postgresql" do
  supports :status => true, :restart => true, :reload => true  
end

#DO ALL BASIC TEMPLATE SETUP HERE
