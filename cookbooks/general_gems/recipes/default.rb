#
# Cookbook Name:: general_gems
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


package "libonig2"
package "libonig-dev"
package "libxml2"
package "libxml2-dev"
package "libxslt1.1"
package "libxslt1-dev"
package "libcurl4-gnutls-dev"
package "unzip"


gem_package "nokogiri" do
  action :install
  version "1.4.1"
end

gem_package "oniguruma" do
  action :install
  version "1.1.0"
end

gem_package "yajl-ruby" do
  action :install
  version '0.7.6'
end

gem_package "rake" do
  action :install
  version '0.8.7'
end

gem_package "rack" do
  action :install
  version '1.0.1'
end

gem_package "rack" do
  action :install
  version '1.1.0'
end

gem_package "riddle" do
  action :install
  version '1.0.10'
end

gem_package "rails" do
  action :install
  version '2.3.8'
end

gem_package "SystemTimer" do
  action :install
  version '1.2'
end

gem_package "macaddr" do
  action :install
  version '1.0.0'
end

gem_package "bson" do
  action :install
  version '1.0.1'
end

gem_package "after_commit" do
  action :install
  version '1.0.7'
end

gem_package "rcov" do
  action :install
  version '0.9.8'
end

gem_package "ppe-panoramio" do
  action :install
  version '2.3.8'
end

gem_package "ppe_api" do
  action :install
  version '2.3.8'
end

gem_package "aws-s3" do
  action :install
  version '0.6.2'
end

gem_package "bson_ext" do
  action :install
  version '1.0.1'
end

