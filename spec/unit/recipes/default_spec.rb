#
# Cookbook:: proj-seagl
# Spec:: default
#
# Copyright:: 2022-2025, Oregon State University
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

describe 'proj-seagl::default' do
  cached(:subject) { chef_run }
  platform 'almalinux', '8'

  include_context 'common_stubs'

  it do
    is_expected.to include_recipe 'sudo::default'
  end

  it do
    is_expected.to create_users_manage('seagl')
    is_expected.to create_sudo('seagl').with(
      user: %w(seagl),
      runas: 'root',
      nopasswd: true
    )
  end

  it do
    is_expected.to install_package(%w(emacs-nox nano))
  end
end
