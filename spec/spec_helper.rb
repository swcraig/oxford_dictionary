require 'simplecov'
SimpleCov.start
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'oxford_dictionary'
require 'webmock/rspec'

TEST_API_ID = 'ID'.freeze
TEST_API_KEY = 'SECRET'.freeze
ACCEPT = 'application/json'.freeze
HEADERS = { 'Accept' => ACCEPT, 'App-Id' => 'ID', 'App-Key' => 'SECRET' }.freeze

def stub_get(path, fixture_name)
  headers = HEADERS
  stub_request(:get, api_url(path))
    .with(headers: headers)
    .to_return(status: 200, body: fixture(fixture_name))
end

def stub_error(path, fixture_name)
  headers = HEADERS
  stub_request(:get, api_url(path))
    .with(headers: headers)
    .to_return(status: 404, body: fixture(fixture_name))
end

def fixture_path(file = nil)
  path = File.expand_path('../fixtures', __FILE__)
  file.nil? ? path : File.join(path, file)
end

def fixture(file)
  File.read(fixture_path(file))
end

def api_url(path)
  "#{OxfordDictionary::DeprecatedRequest::BASE}/#{path}"
end

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
