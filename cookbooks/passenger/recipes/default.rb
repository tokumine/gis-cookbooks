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