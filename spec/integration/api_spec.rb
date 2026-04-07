# frozen_string_literal: true

require 'oxford_dictionary'
require 'webmock'
require 'json'

RSpec.describe 'Oxford Dictionary API Integration Tests' do
  # Fail fast if credentials are not available
  app_id = ENV.fetch('APP_ID', nil)
  app_key = ENV.fetch('APP_KEY', nil)

  if app_id.nil? || app_key.nil?
    raise <<~ERROR
      Integration tests require Oxford Dictionary API credentials.

      Please set the following environment variables:
        export APP_ID=<your-app-id>
        export APP_KEY=<your-app-key>

      Then run:
        bundle exec rake integration

      Get credentials at: https://developer.oxforddictionaries.com/
    ERROR
  end

  before :all do
    # Disable WebMock so real HTTP calls go through
    WebMock.disable!
  end

  after :all do
    # Re-enable WebMock for other test suites
    WebMock.enable!
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

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def print_response(response)
    cyan = "\e[36m"
    reset = "\e[0m"

    puts "#{cyan}  Deserialized OpenStruct (property access):#{reset}"
    puts "#{cyan}    response.class = #{response.class}#{reset}"
    puts "#{cyan}    response.to_h.keys = #{response.to_h.keys.inspect}#{reset}"
    puts("#{cyan}    response.id = #{response.id.inspect}#{reset}") if response.respond_to?(:id)
    puts("#{cyan}    response.results.class = #{response.results.class}#{reset}") \
      if response.respond_to?(:results) && response.results
    puts("#{cyan}    response.word = #{response.word.inspect}#{reset}") if response.respond_to?(:word)

    puts "\n  Full Response (as JSON):"
    response_hash = response.to_h
    puts(JSON.pretty_generate(response_hash).lines.map { |line| "    #{line}" })
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  describe 'Entries endpoint' do
    it 'retrieves entry for a word' do
      puts "\n[entries] Calling: client.entry(word: 'apple', dataset: 'en-gb', params: {})"
      response = client.entry(word: 'apple', dataset: 'en-gb', params: {})
      print_response(response)

      expect(response).to be_an(OpenStruct)
      expect(response).not_to be_nil
    end
  end

  describe 'Lemmas endpoint' do
    it 'retrieves lemmas for a word' do
      puts "\n[lemmas] Calling: client.lemma(word: 'able', language: 'en', params: {})"
      response = client.lemma(word: 'able', language: 'en', params: {})
      print_response(response)

      expect(response).to be_an(OpenStruct)
      expect(response).not_to be_nil
    end
  end

  describe 'Translations endpoint' do
    it 'retrieves translations for a word' do
      puts "\n[translations] Calling: client.translation(word: 'assess', " \
           "source_language: 'en', target_language: 'es', params: {})"
      response = client.translation(
        word: 'assess',
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
      puts "\n[sentences] Calling: client.sentence(word: 'analysis', language: 'en', params: {})"
      response = client.sentence(word: 'analysis', language: 'en', params: {})
      print_response(response)

      expect(response).to be_an(OpenStruct)
      expect(response).not_to be_nil
    end
  end

  describe 'Thesaurus endpoint' do
    it 'retrieves thesaurus data (synonyms/antonyms) for a word' do
      puts "\n[thesaurus] Calling: client.thesaurus(word: 'amiable', language: 'en', params: {})"
      response = client.thesaurus(word: 'amiable', language: 'en', params: {})
      print_response(response)

      expect(response).to be_an(OpenStruct)
      expect(response).not_to be_nil
    end
  end

  describe 'Search endpoint' do
    it 'searches for words' do
      puts "\n[search] Calling: client.search(language: 'en-gb', params: { q: 'about' })"
      response = client.search(language: 'en-gb', params: { q: 'about' })
      print_response(response)

      expect(response).to be_an(OpenStruct)
      expect(response).not_to be_nil
    end

    it 'searches for translations' do
      puts "\n[search_translation] Calling: client.search_translation(" \
           "source_language: 'en', target_language: 'es', params: { q: 'able' })"
      response = client.search_translation(
        source_language: 'en',
        target_language: 'es',
        params: { q: 'able' }
      )
      print_response(response)

      expect(response).to be_an(OpenStruct)
      expect(response).not_to be_nil
    end
  end
end
