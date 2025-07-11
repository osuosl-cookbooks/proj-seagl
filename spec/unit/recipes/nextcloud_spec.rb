#
# Cookbook:: proj-seagl
# Spec:: nextcloud
#
# Copyright:: 2023-2025, Oregon State University
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

describe 'proj-seagl::nextcloud' do
  ALL_PLATFORMS.each do |p|
    context "#{p[:platform]} #{p[:version]} #{p[:log_level]}" do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(p).converge(described_recipe)
      end

      include_context 'common_stubs'

      before do
        stub_data_bag_item('proj-seagl', 'nextcloud').and_return(
          db: {
            host: '127.0.0.1',
            user: 'seagl_nextcloud',
            passwd: 'seagl_password',
            name: 'seagl_nextcloud',
          },
          "admin_passwd": 'unguessable',
          "extra_config": {
            'sentry.dsn' => 'sentry_dsn_fake',
            'sentry.public-dsn' => 'sentry_public_dsn_fake',
            'sentry.csp-report-url' => 'sentry_csp_report_url_fake',
          }
        )
      end

      it do
        is_expected.to create_osl_nextcloud('cloud.seagl.org').with(
          database_name: 'seagl_nextcloud',
          database_user: 'seagl_nextcloud',
          database_host: '127.0.0.1',
          database_password: 'seagl_password',
          nextcloud_admin_password: 'unguessable',
          mail_domain: 'cloud.seagl.org'
        )
      end
    end
  end
end
