require 'spec_helper'

describe 'V1 inflections delegations' do
  let(:client) do
    OxfordDictionary.new(app_id: ENV['APP_ID'], app_key: ENV['APP_KEY'])
  end

  context '#inflection without filters' do
    let(:resp) { client.inflection('changed') }
    it 'makes a request to the proper V2 endpoint' do
      VCR.use_cassette('v1_inflection') do
        expect_any_instance_of(OxfordDictionary::Request).
          to receive(:get).
          with(uri: URI('lemmas/en/changed')).
          once.
          and_call_original
        expect(resp.results.first.id).to eq('changed')
      end
    end
  end

  context '#inflection with filters' do
    let(:resp) do
      client.inflection(
        'changed',
        grammaticalFeatures: %w(singular past), lexicalCategory: 'noun'
      )
    end
    it 'makes a request to the proper V2 endpoint' do
      VCR.use_cassette('v1_inflection_filters') do
        expect_any_instance_of(OxfordDictionary::Request).
          to receive(:get).
          with(uri: URI('lemmas/en/changed?grammaticalFeatures=singular%2Cpast&lexicalCategory=noun')).
          once.
          and_call_original
        expect(resp.results).to eq([])
      end
    end
  end
end
