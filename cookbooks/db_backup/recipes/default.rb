#
# Cookbook Name:: db_backup
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
include_recipe 'postfix'

gem_package "backup" do
  action :install
  version "2.3.1"
end

execute "initialise backup directory" do
  command "backup --setup"
end

template "/opt/backup/config/backup.rb" do
  source "backup.rb.erb"
end

cron "backup postgres" do
  hour "1"
  command "backup --run postgres"
end

log "[BACKUPS] configure backups in /opt/backup/config/backup.rb"
log "[BACKUPS] See http://wiki.github.com/meskyanichi/backup/getting-started-unix"
log "[BACKUPS] Postgres scheduled to backup to S3 at 1am daily"





  