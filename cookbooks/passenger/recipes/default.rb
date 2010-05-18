#
# Cookbook Name:: nginx
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
package "libperl5.10"
package "libxslt1.1"
package "libgeoip1"
package "libgd2-noxpm"
package "libgeoip-dev"
package "libxslt1-dev"
package "libpcre3-dev"
package "libgd2-noxpm-dev"
package "libssl-dev"
nginx_path = "/tmp/nginx-#{node[:passenger][:nginx][:nginx_version]}"

gem_package "passenger" do
  version node[:passenger][:nginx][:passenger_version]
end

remote_file "download_nginx" do
  path "#{nginx_path}.tar.gz"
  source "http://sysoev.ru/nginx/nginx-#{node[:passenger][:nginx][:nginx_version]}.tar.gz"
end

execute "extract nginx" do
  command "tar -C /tmp -xzf #{nginx_path}.tar.gz"
  not_if { File.exists?(nginx_path) }
end

# default options from Ubuntu 8.10
compile_options = ["--conf-path=/etc/nginx/nginx.conf",
                   "--error-log-path=/var/log/nginx/error.log",
                   "--pid-path=/var/run/nginx.pid",
                   "--lock-path=/var/lock/nginx.lock",
                   "--http-log-path=/var/log/nginx/access.log",
                   "--http-client-body-temp-path=/var/lib/nginx/body",
                   "--http-proxy-temp-path=/var/lib/nginx/proxy",
                   "--http-fastcgi-temp-path=/var/lib/nginx/fastcgi",
                   "--with-http_stub_status_module",
                   "--with-http_ssl_module",
                   "--with-http_gzip_static_module",
                   "--with-http_geoip_module",
                   "--with-file-aio"].join(" ")


execute "compile nginx with passenger" do
  command "passenger-install-nginx-module --auto --prefix=/usr --nginx-source-dir=#{nginx_path} --extra-configure-flags=\"#{compile_options}\""
  #notifies :restart, resources(:service => "nginx")
  not_if { File.exists? "/usr/sbin/nginx"}
end

template "/etc/init.d/nginx start script" do
  path "/etc/init.d/nginx"
  source "start_script.erb"
  owner "root"
  group "root"
  mode 0755  
end

execute "add nginx startup script to server boot" do 
  command "/usr/sbin/update-rc.d -f nginx defaults"
end

service "nginx" do
  supports :status => true, :restart => true, :reload => true  
end

directory "/var/lib/nginx" do
  owner "root"
  group "root"
  mode "0755"
  action :create
  not_if "test -d /var/lib/nginx"
  notifies :start, resources(:service => "nginx")
end

#CREATE THE CONF.D DIRECTORY
directory "#{node[:nginx][:conf_dir]}" do
  owner "root"
  group "root"
  mode "0755"
  action :create
  not_if "test -d #{node[:nginx][:conf_dir]}"
end

#CREATE NGINX LOG
directory node[:nginx][:log_dir] do
  mode 0755
  owner node[:nginx][:user]
  action :create
  not_if "test -d #{node[:nginx][:log_dir]}"
end

#ROTATE NGINX LOG
template "/etc/logrotate.d/nginx" do
  source "nginx.logrotate.erb"
  owner "root"
  group "root"
  mode 0755
  backup false
  action :create
end


#ENABLE/DISABLE SITES
%w{nxensite nxdissite}.each do |nxscript|
  template "/usr/sbin/#{nxscript}" do
    source "#{nxscript}.erb"
    mode 0755
    owner "root"
    group "root"
  end
end

#CREATE NGINX USER
execute "add nginx user" do
  command "adduser --system --no-create-home --disabled-login --disabled-password --group #{node[:nginx][:user]}"
end

#SETUP NGINX CONF FILE
template "nginx.conf" do
  path "#{node[:nginx][:dir]}/nginx.conf"
  source "nginx.conf.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :reload, resources(:service => "nginx")
end

directory "#{node[:nginx][:dir]}/helpers"

# helpers to be included in your vhosts
node[:nginx][:helpers].each do |h|
  template "#{node[:nginx][:dir]}/helpers/#{h}.conf" do
    notifies :reload, resources(:service => "nginx")
  end
end

#make sites available and sites-enabled
directory "#{node[:nginx][:dir]}/sites-available"
directory "#{node[:nginx][:dir]}/sites-enabled"

#ADD PASSENGER SPECIFICS TO THE NGINX LOAD PATH
template node[:nginx][:conf_dir] + "/passenger.conf" do
  source "passenger.conf.erb"
  owner "root"
  group "root"
  mode 0755
  notifies :restart, resources(:service => "nginx")
end

#PREP BASIC WWW LOCATION
default_site = "#{node[:web][:dir]}/#{node[:web][:default_site]}"
directory default_site do
  mode 0755
  owner node[:nginx][:user]
  action :create
  recursive true  
  not_if "test -d #{default_site}"
end

directory "#{default_site}/public" do
  mode 0755
  owner node[:nginx][:user]
  action :create
  recursive true  
  not_if "test -d #{default_site}/public"
end

directory "#{default_site}/tmp" do
  mode 0755
  owner node[:nginx][:user]
  action :create
  recursive true  
  not_if "test -d #{default_site}/tmp"
end


#ADD BASIC SITE
template node[:nginx][:dir] + "/sites-available/#{node[:web][:default_site]}" do
  source "#{node[:web][:default_site]}.erb"
  owner "root"
  group "root"
  mode 0755
end

#ADD BASIC CONFIG.RU
template "#{default_site}/config.ru" do
  source "config.ru.erb"
  owner node[:nginx][:user]
  owner node[:nginx][:user]
  mode 0755
end


#ADD BASIC HELLO WORLD
template "#{default_site}/public/app.rb" do
  source "app.rb.erb"
  owner node[:nginx][:user]
  owner node[:nginx][:user]
  mode 0755
  notifies :restart, resources(:service => "nginx")
end

#ENABLE THE SITE
execute "enable the default site" do
 command "nxensite #{node[:web][:default_site]}"
 notifies :restart, resources(:service => "nginx")
end
