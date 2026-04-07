# frozen_string_literal: true

require 'oxford_dictionary'
require 'webmock'
require 'json'

RSpec.describe 'Oxford Dictionary API Integration Tests' do
  # Skip entire suite if credentials are not available
  app_id = ENV.fetch('APP_ID', nil)
  app_key = ENV.fetch('APP_KEY', nil)

  before :all do
    # Disable WebMock so real HTTP calls go through
    WebMock.disable!
  end

  after :all do
    # Re-enable WebMock for other test suites
    WebMock.enable!
  end

  # Skip all tests if credentials not set
  before do
    skip 'Set APP_ID and APP_KEY environment variables to run integration tests' \
      if app_id.nil? || app_key.nil?
  end

  # Rate limiting: sleep between each test
  around do |example|
    example.run
    sleep 2
  end

  let(:client) do
    OxfordDictionary::Client.new(
      app_id: app_id,
      app_key: app_key
    )
  end

  def print_response(response)
    puts '  Response (as JSON):'
    response_hash = response.to_h
    puts(JSON.pretty_generate(response_hash).lines.map { |line| "    #{line}" })
  end

  describe 'Entries endpoint' do
    it 'retrieves entry for a word' do
      puts "\n[entries] Calling: client.entry(word: 'vapid', dataset: 'en-gb', params: {})"
      response = client.entry(word: 'vapid', dataset: 'en-gb', params: {})
      print_response(response)

      expect(response).to be_an(OpenStruct)
      expect(response).not_to be_nil
    end
  end

  describe 'Lemmas endpoint' do
    it 'retrieves lemmas for a word' do
      puts "\n[lemmas] Calling: client.lemma(word: 'condition', language: 'en', params: {})"
      response = client.lemma(word: 'condition', language: 'en', params: {})
      print_response(response)

      expect(response).to be_an(OpenStruct)
      expect(response).not_to be_nil
    end
  end

  describe 'Translations endpoint' do
    it 'retrieves translations for a word' do
      puts "\n[translations] Calling: client.translation(word: 'condition', " \
           "source_language: 'en', target_language: 'es', params: {})"
      response = client.translation(
        word: 'condition',
        source_language: 'en',
        target_language: 'es',
        params: {}
      )
      print_response(response)

      expect(response).to be_an(OpenStruct)
      expect(response).not_to be_nil
    end
  end

  describe 'Sentences endpoint' do
    it 'retrieves example sentences for a word' do
      puts "\n[sentences] Calling: client.sentence(word: 'paraphrase', language: 'en', params: {})"
      response = client.sentence(word: 'paraphrase', language: 'en', params: {})
      print_response(response)

      expect(response).to be_an(OpenStruct)
      expect(response).not_to be_nil
    end
  end

  describe 'Thesaurus endpoint' do
    it 'retrieves thesaurus data (synonyms/antonyms) for a word' do
      puts "\n[thesaurus] Calling: client.thesaurus(word: 'book', language: 'en', params: {})"
      response = client.thesaurus(word: 'book', language: 'en', params: {})
      print_response(response)

      expect(response).to be_an(OpenStruct)
      expect(response).not_to be_nil
    end
  end

  describe 'Search endpoint' do
    it 'searches for words' do
      puts "\n[search] Calling: client.search(language: 'en-gb', params: { q: 'vapid' })"
      response = client.search(language: 'en-gb', params: { q: 'vapid' })
      print_response(response)

      expect(response).to be_an(OpenStruct)
      expect(response).not_to be_nil
    end

    it 'searches for translations' do
      puts "\n[search_translation] Calling: client.search_translation(" \
           "source_language: 'en', target_language: 'es', params: { q: 'condition' })"
      response = client.search_translation(
        source_language: 'en',
        target_language: 'es',
        params: { q: 'condition' }
      )
      print_response(response)

      expect(response).to be_an(OpenStruct)
      expect(response).not_to be_nil
    end
  end
end
