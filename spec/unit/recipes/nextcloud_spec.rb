#
# Cookbook:: proj-seagl
# Spec:: nextcloud
#
# Copyright:: 2023, Oregon State University
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

require_relative '../../spec_helper'
require 'spec_helper'

describe 'proj-seagl::nextcloud' do
  cached(:subject) { chef_run }
  platform 'centos', '8'

  include_context 'stubs'

  %w(
    osl-mysql::server
  ).each do |recipe|
    it do
      is_expected.to include_recipe recipe
    end
  end

  it do
    is_expected.to create_percona_mysql_database('db_nextcloud')
    is_expected.to create_percona_mysql_user('db_nextcloud_user')
    is_expected.to create_osl_nextcloud('seagl_cloud')
  end
end
