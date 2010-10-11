#
# Cookbook Name:: memcached
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

package "memcached"
package "libsasl2-dev"
package "libmemcached-dev" 
package "libmemcached-dbg"

service "memcached" do
  supports :status => true, :restart => true, :reload => true  
  action :stop
end

memory = `cat /proc/meminfo | grep "MemTotal"`.match(/\d+/).to_s.to_i * 1024

template "/etc/memcached.conf" do
  source "memcached.conf.erb"
  mode 0755
  owner "root"
  group "root"  
	variables(
		:ram_mb => memory / 1024 / 1024,
		:memcached_mb => (memory / 1024 / 1024) / 8 #NOT USED YET
	)
end

gem_package "memcache-client" do
  action :install
  version "1.8.3"
end

gem_package "memcached" do
  action :install
  version "0.19.5"
end