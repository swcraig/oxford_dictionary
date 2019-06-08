require 'spec_helper'
require 'oxford_dictionary/request'

RSpec.describe OxfordDictionary::Request do
  let(:app_id) { ENV['APP_ID'] }
  let(:app_key) { ENV['APP_KEY'] }
  let(:request_client) { described_class.new(app_id: app_id, app_key: app_key) }

  describe '#get' do
    subject { request_client.get(uri: uri) }
    let(:uri) { 'whatever/wherever' }

    let(:https_double) { double }
    let(:expected_response) { 'whatever' }

    let(:expected_request_object) do
      Net::HTTP::Get.new(uri).tap do |request|
        request['Accept'] = 'application/json'
        request['app_id'] = app_id
        request['app_key'] = app_key
      end
    end

    it 'GETs a page correctly' do
      expect(Net::HTTP).
        to receive(:start).
        and_yield(https_double).
        and_return(expected_response)

      expect(https_double).to receive(:request)

      expect(subject).to eq(expected_response)
    end
  end
end
