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
  ALL_PLATFORMS.each do |platform|
    context "on platform #{platform[:platform]} #{platform[:version]}" do
      let(:runner) do
        ChefSpec::SoloRunner.new(
          platform.dup.merge(step_into: ['osl_nextcloud'])
        )
      end

      include_context 'stubs'

      occ_config = '{"system": {
                      "trusted_domains": [ "localhost", "cloud.seagl.org" ],
                      "redis": {
                        "host": "***REMOVED SENSITIVE VALUE***",
                        "port": "6379"
                      }
                    }}'
      occ_config = JSON.parse(occ_config)

      context 'nextcloud not installed' do
        before do
          stubs_for_provider('osl_nextcloud[test]') do |provider|
            allow(provider).to receive_shell_out('php occ config:list', { cwd: '/usr/share/nextcloud/', user: 'apache', group: 'apache' }).and_return(
              double(stdout: '{"system": {"trusted_domains": ["localhost"]}}', exitstatus: 0)
            )
          end
          stubs_for_resource('execute[occ-nextcloud]') do |resource|
            allow(resource).to receive_shell_out('php occ | grep maintenance:install', { cwd: '/usr/share/nextcloud/', user: 'apache', group: 'apache' }).and_return(
              double(exitstatus: 0)
            )
          end
        end

        let(:node) { runner.node }
        cached(:chef_run) { runner.converge(described_recipe) }

        it 'converges successfully' do
          expect { chef_run }.to_not raise_error
        end

        it do
          expect(chef_run).to create_template('/etc/php.ini').with(
            variables: {
              directives: { 'post_max_size' => '65M',
                            'memory_limit' => '512M',
                            'upload_max_filesize' => '60M',
                            'output_buffering' => false },
            }
          )
        end

        describe 'included recipes' do
          %w(
            osl-apache
            osl-apache::mod_php
            osl-php
            osl-repos::epel
          ).each do |r|
            it do
              expect(chef_run).to include_recipe(r)
            end
          end
        end

        it { expect(chef_run).to install_package(%w(nextcloud redis)) }

        it { expect(chef_run).to create_directory('/etc/httpd/nextcloud') }

        %w(
          /etc/httpd/nextcloud/nextcloud-access.conf.avail
          /etc/httpd/nextcloud/nextcloud-auth-any.inc
          /etc/httpd/nextcloud/nextcloud-auth-local.inc
          /etc/httpd/nextcloud/nextcloud-auth-none.inc
          /etc/httpd/nextcloud/nextcloud-defaults.inc
        ).each do |f|
          it { expect(chef_run).to create_cookbook_file(f) }
        end

        it { expect(chef_run).to enable_service('redis') }
        it { expect(chef_run).to start_service('redis') }

        it { expect(chef_run).to run_execute('occ-nextcloud').with(user: 'apache') }
        it { expect(chef_run).to_not run_execute('trusted-domains-localhost') }
        it { expect(chef_run).to run_execute('trusted-domains-cloud.seagl.org').with(user: 'apache') }
        it { expect(chef_run).to run_execute('redis-host') }
        it { expect(chef_run).to run_execute('redis-port') }
      end

      context 'nextcloud installed' do
        before do
          allow_any_instance_of(OSLNextcloud::Cookbook::Helpers).to receive(:can_install?).and_return(false)
          allow_any_instance_of(OSLNextcloud::Cookbook::Helpers).to receive(:osl_nextcloud_config).and_return(occ_config)
        end
        let(:node) { runner.node }
        cached(:chef_run) { runner.converge(described_recipe) }
        it { expect(chef_run).to_not run_execute('trusted-domains-localhost') }
        it { expect(chef_run).to_not run_execute('trusted-domains-cloud.seagl.org') }
        it { expect(chef_run).to_not run_execute('occ-nextcloud') }
        it { expect(chef_run).to_not run_execute('redis-host') }
        it { expect(chef_run).to_not run_execute('redis-port') }
      end
    end
  end
end
