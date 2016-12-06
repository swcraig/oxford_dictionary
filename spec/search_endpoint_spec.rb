require 'spec_helper'

describe OxfordDictionary::Endpoints::SearchEndpoint do
  before do
    stub_get('search/en?q=vapid&prefix=false', 'search_vapid.json')
    stub_get(
      'search/en?q=condition&prefix=true',
      'search_condition_prefix.json'
    )
    stub_get(
      'search/en/translations=id?q=eye&prefix=false',
      'search_eye_id.json'
    )
  end
  let(:client) { OxfordDictionary.new(app_id: 'ID', app_key: 'SECRET') }

  context '#search without filters' do
    let(:resp) { client.search('vapid') }
    it 'is a search request' do
      expect(resp.results).to be_an Array
      expect(resp.results[0].match_string).to eq('vapid')
    end
  end

  context '#search as a prefix' do
    let(:resp) { client.search('condition', prefix: true) }
    it 'searches as a prefix' do
      expect(resp.results[0].match_type).to eq('inflection')
      expect(resp.results[0].word).to eq('condition')
    end
  end

  context '#search with translations argument' do
    let(:resp) { client.search('eye', translations: 'id') }
    it 'has the desired translations' do
      expect(resp.results.size).to eq(2)
      expect(resp.results[0].id).to eq('eye')
    end
  end
end
