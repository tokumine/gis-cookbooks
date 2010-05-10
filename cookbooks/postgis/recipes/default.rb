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
# postGIS 1.4
include_recipe 'gdal'
include_recipe 'geos'
include_recipe 'proj'
include_recipe 'postgres'
package 'postgis'
package 'postgresql-8.4-postgis'

#DO ALL BASIC TEMPLATE SETUP HERE
bash "configure postgres" do
  user "postgres"  
  code <<-EOH    
  createdb -E UTF8 -O postgres template_postgis
  createlang plpgsql -d template_postgis
  psql -d template_postgis -f /usr/share/postgresql/8.4/contrib/postgis.sql
  psql -d template_postgis -f /usr/share/postgresql/8.4/contrib/spatial_ref_sys.sql
  ldconfig
  EOH
  not_if { `psql -d template_postgis  -c "select * from pg_tables where schemaname='public'" | grep 'spatial_ref_sys'`}
end


#CONFIGURE PG CONFIG FILES HERE - FIREWALL FOR EC2 FILES
# create non-postgres user
# allow postgres users to connect from other AWS
# configure memory use in a config file depending on memory useage




