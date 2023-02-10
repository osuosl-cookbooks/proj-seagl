#
# Cookbook:: osl-nextcloud
# Recipe:: default
#
# Copyright:: 2022-2023, Oregon State University
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

node.override['percona']['version'] = '5.7'
node.default['percona']['server']['root_password'] = 'nextcloud'
node.default['percona']['backup']['password'] = 'nextcloud'

dbcreds = data_bag_item('proj-seagl', 'credentials')

include_recipe 'osl-mysql::server'

percona_mysql_database dbcreds['db_dbname'] do
  password node['percona']['server']['root_password']
end

percona_mysql_user dbcreds['db_user'] do
  database_name dbcreds['db_dbname']
  password dbcreds['db_passw']
  host dbcreds['db_host']
  ctrl_password node['percona']['server']['root_password']
  action [:create, :grant]
end

service 'apache2' do
  service_name lazy { apache_platform_service_name }
  supports restart: true, status: true, reload: true, enable: true
  action :nothing
end

osl_nextcloud 'test' do
  version '23'
  server_name 'nextcloud.example.com'
  database_host 'localhost'
  database_name 'nextcloud'
  database_user 'nextcloud'
  database_password 'nextcloud'
  nextcloud_admin_user 'admin'
  nextcloud_admin_password 'unguessable'
  server_aliases %w(localhost nextcloud.example.com)
end
