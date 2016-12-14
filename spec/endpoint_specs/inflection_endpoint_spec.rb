require 'spec_helper'

describe OxfordDictionary::Endpoints::InflectionEndpoint do
  before do
    stub_get('inflections/en/changed', 'inflection_changed.json')
    filters = 'grammaticalFeatures=singular,past;lexicalCategory=noun'
    stub_get(
      "inflections/en/changed/#{filters}",
      'inflection_filters_changed.json'
    )
  end
  let(:client) { OxfordDictionary.new(app_id: 'ID', app_key: 'SECRET') }

  context '#inflection without filters' do
    let(:resp) { client.inflection('changed') }
    it 'is an inflection request' do
      lex_entry = resp.lexical_entries[0]
      expect(lex_entry.grammatical_features).to be_an Array
      expect(lex_entry.grammatical_features[0].text).to eq('Past')
      expect(lex_entry.lexical_category).to eq('Verb')
      expect(lex_entry.inflection_of).to be_an Array
    end
  end

  context '#inflection with filters' do
    let(:resp) do
      client.inflection(
        'changed',
        grammaticalFeatures: %w(singular past), lexicalCategory: 'noun'
      )
    end
    it 'properly requests with filters' do
      lex_entry = resp.lexical_entries[0]
      expect(lex_entry.grammatical_features[0].text).to eq('Singular')
      expect(lex_entry.lexical_category).to eq('Noun')
      expect(lex_entry.inflection_of).to be_an Array
    end
  end
end
