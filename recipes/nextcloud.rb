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

dbcreds = data_bag_item('proj-seagl', 'dbcredentials')
servercreds = data_bag_item('proj-seagl', 'servercredentials')
nextcloudcreds = data_bag_item('proj-seagl', 'nextcloudcredentials')

node.override['percona']['version'] = '5.7'
node.default['percona']['server']['root_password'] = servercreds['root_password']
node.default['percona']['backup']['password'] = servercreds['backup_password']

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
  server_name 'cloud.seagl.org'
  database_name dbcreds['db_dbname']
  database_user dbcreds['db_user']
  database_host dbcreds['db_host']
  database_password dbcreds['db_passw']
  nextcloud_admin_user nextcloudcreds['admin_user']
  nextcloud_admin_password nextcloudcreds['admin_pass']
  server_aliases %w(localhost cloud.seagl.org)
  sensitive false
end
