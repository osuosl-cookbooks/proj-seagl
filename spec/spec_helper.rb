require 'chefspec'
require 'chefspec/berkshelf'

ALMA_8 = {
  platform: 'almalinux',
  version: '8',
  log_level: :warn,
}.freeze

ALMA_9 = {
  platform: 'almalinux',
  version: '9',
  log_level: :warn,
}.freeze

ALMA_10 = {
  platform: 'almalinux',
  version: '10',
  log_level: :warn,
}.freeze

ALL_PLATFORMS = [
  ALMA_8,
  ALMA_9,
  ALMA_10,
].freeze

RSpec.configure do |config|
  config.log_level = :warn
end

shared_context 'common_stubs' do
  before do
    stub_search('users', '*:*').and_return([])
  end
end
