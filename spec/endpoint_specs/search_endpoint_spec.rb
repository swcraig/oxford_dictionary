require 'spec_helper'

describe 'V1 search delegations' do
  let(:client) do
    OxfordDictionary.new(app_id: ENV['APP_ID'], app_key: ENV['APP_KEY'])
  end
  let(:response_double) { double(body: {}.to_json) }

  context '#search without filters' do
    let(:resp) { client.search('vapid') }

    it 'makes a request to the proper V2 endpoint' do
      VCR.use_cassette('v1_search') do
        expect_any_instance_of(OxfordDictionary::Request).
          to receive(:get).
          with(uri: URI('search/en-gb?q=vapid')).
          once.
          and_return(response_double)
        resp
      end
    end
  end

  context '#search as a prefix' do
    let(:resp) { client.search('condition', prefix: true) }
    it 'makes a request to the proper V2 endpoint' do
      VCR.use_cassette('v1_search_prefix') do
        expect_any_instance_of(OxfordDictionary::Request).
          to receive(:get).
          with(uri: URI('search/en-gb?prefix=true&q=condition')).
          once.
          and_return(response_double)
        resp
      end
    end
  end

  context '#search with translations argument' do
    let(:resp) { client.search('eye', translations: 'id') }
    it 'makes a request to the proper V2 endpoint' do
      VCR.use_cassette('v1_search_translation') do
        expect_any_instance_of(OxfordDictionary::Request).
          to receive(:get).
          with(uri: URI('search/translations/en-gb/id?q=eye')).
          once.
          and_return(response_double)
        resp
      end
    end
  end
end
