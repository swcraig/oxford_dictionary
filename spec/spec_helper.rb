# frozen_string_literal: true

require 'simplecov'
SimpleCov.start
$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'oxford_dictionary'
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'fixtures/vcr_cassettes'
  config.hook_into :webmock
  config.filter_sensitive_data('APP_ID') { ENV.fetch('APP_ID', nil) }
  config.filter_sensitive_data('APP_KEY') { ENV.fetch('APP_KEY', nil) }
end

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
