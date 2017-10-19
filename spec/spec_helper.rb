RSpec.configure do |c|
  c.before(:each) { Time.now.utc.tap { | now| Time.stubs(:now).returns(now) } }
end

require 'travis/support/testing/webmock'
require 'travis/live/pusher'

require 'mocha'

include Mocha::API

RSpec.configure do |c|
  c.mock_with :mocha
  c.alias_example_to :fit, :focused => true
  c.filter_run :focused => true
  c.run_all_when_everything_filtered = true
  # c.backtrace_exclusion_patterns = []

  c.include Travis::Support::Testing::Webmock

  c.before :each do
    Travis.config.oauth2 ||= {}
    Travis.config.oauth2.scope = 'public_repo,user'
  end
end
