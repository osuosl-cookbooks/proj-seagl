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
# servercreds = data_bag_item('proj-seagl', 'servercredentials')
nextcloudcreds = data_bag_item('proj-seagl', 'nextcloudcredentials')

# service 'apache2' do
#   service_name lazy { apache_platform_service_name }
#   supports restart: true, status: true, reload: true, enable: true
#   action :nothing
# end

osl_nextcloud 'seagl_cloud' do
  version '23'
  server_name 'cloud.seagl.org'
  database_name dbcreds['db_dbname']  # Change this
  database_user dbcreds['db_user']    # Change this
  database_host dbcreds['db_host']    # Change this
  database_password dbcreds['db_passw'] # Change this
  nextcloud_admin_user nextcloudcreds['admin_user']
  nextcloud_admin_password nextcloudcreds['admin_pass']
  server_aliases %w(localhost cloud.seagl.org)
  sensitive false   # Change this
end
