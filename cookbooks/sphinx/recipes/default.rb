#
# Cookbook Name:: sphinx
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


# Dev libraries for postgres 8.4
package "postgresql-server-dev-8.4"

# Sphinx 0.9.9
remote_file "download sphinx" do
  path "/tmp/sphinx-0.9.9.tar.gz"
  source "http://sphinxsearch.com/downloads/sphinx-0.9.9.tar.gz"
end 
 
 # remove with dpkg -r sphinx
bash "install sphinx" do
  user "root"
  cwd "/tmp"
  code <<-EOH    
  tar zxvf sphinx-0.9.9.tar.gz
  cd /tmp/sphinx-0.9.9
  ./configure --with-pgsql --without-mysql
  make
  checkinstall --pkgname sphinx --pkgversion 0.9.9-src --default 
  EOH
  only_if { `which searchd`.empty?}
end

gem_package "thinking_sphinx" do
  action :install
  version "1.3.16"
end