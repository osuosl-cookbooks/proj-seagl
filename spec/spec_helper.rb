require 'chefspec'
require 'chefspec/berkshelf'

CENTOS_7 = {
  platform: 'centos',
  version: '7',
}.freeze

CENTOS_8 = {
  platform: 'centos',
  version: '8',
}.freeze

ALL_PLATFORMS = [
  CENTOS_7,
  CENTOS_8,
].freeze

RSpec.configure do |config|
  config.log_level = :warn
end

shared_context 'stubs' do
  before do
    stub_search('users', '*:*').and_return([])
    stub_data_bag_item('nextcloud', 'credentials').and_return(
      'id' => 'credentials',
      'db_host' => 'localhost',
      'db_port' => '3306',
      'db_user' => 'nextcloud',
      'db_passw' => 'nextcloud',
      'db_dbname' => 'nextcloud'
    )
    stub_command("mysqladmin --user=root --password='' version").and_return(true)
  end
end
