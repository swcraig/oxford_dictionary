# frozen_string_literal: true

require 'spec_helper'

describe OxfordDictionary::Endpoints::WordFrequencyEndpoint do
  before do
    stub_get(
      'stats/frequency/word/en/lemma=spring',
      'word_frequency_spring.json',
    )
    stub_get(
      'stats/frequency/word/en/lemma=spring;lexicalCategory=noun',
      'word_frequency_spring_noun.json',
    )
    stub_get(
      'stats/frequency/word/en/lemma=spring;lexicalCategory=verb',
      'word_frequency_spring_verb.json',
    )
  end

  let(:client) { OxfordDictionary.new(app_id: 'ID', app_key: 'SECRET') }

  context '#word_frequency with lemma' do
    let(:resp) { client.word_frequency(lemma: 'spring') }

    it 'it has metadata' do
      metadata = resp.metadata
      expect(metadata.language).to eq('en')
      expect(metadata.options.lemma).to eq('spring')
    end

    it 'has result' do
      result = resp.result
      expect(result.frequency).to be_an Integer
      expect(result.lemma).to eq('spring')
      expect(result.match_count).to be_an Integer
      expect(result.normalized_frequency).to be_a Float
    end
  end

  context '#word_frequency with lemma and lexicalCategory' do
    let(:resp) { client.word_frequency(lemma: 'spring') }

    it 'it has metadata' do
      metadata = resp.metadata
      expect(metadata.language).to eq('en')
      expect(metadata.options.lemma).to eq('spring')
    end

    it 'has result' do
      result = resp.result
      expect(result.frequency).to be_an Integer
      expect(result.lemma).to eq('spring')
      expect(result.match_count).to be_an Integer
      expect(result.normalized_frequency).to be_a Float
    end
  end
end
