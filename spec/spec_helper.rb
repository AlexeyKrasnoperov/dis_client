require 'distribusion_client'
require 'vcr'
require 'webmock/rspec'

VCR.configure do |c|
  c.cassette_library_dir = File.expand_path('../support/vcr_cassettes', __FILE__)
  c.hook_into :webmock
  c.default_cassette_options = { erb: true }
  c.allow_http_connections_when_no_cassette = false
end

RSpec.configure do |config|
  config.filter_run :focus
  config.run_all_when_everything_filtered = true
  config.default_formatter = 'doc'
  config.profile_examples = false
  config.order = :random
  Kernel.srand config.seed
  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end
  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
    mocks.verify_partial_doubles = true
  end
  config.raise_errors_for_deprecations!
  config.expose_dsl_globally = false
end

srand RSpec.configuration.seed

def json_body(file)
  File.read(File.expand_path("../support/fixtures/#{file}.json", __FILE__))
end
