require 'spec_helper'

describe 'V1 entry delegations' do
  let(:base_url) { 'https://od-api.oxforddictionaries.com/api/v2' }
  let(:client) do
    OxfordDictionary.new(app_id: ENV['APP_ID'], app_key: ENV['APP_KEY'])
  end
  let(:response_double) { double(body: {}.to_json) }

  context '#entry without filters' do
    let(:resp) { client.entry('ace') }
    it 'hits the expected endpoint' do
      VCR.use_cassette('v1_entry') do
        expect_any_instance_of(OxfordDictionary::Request).
          to receive(:get).
          with(uri: URI("entries/en-gb/ace")).
          once.
          and_call_original
        expect(resp.id).to eq('ace')
      end
    end
  end

  context '#entry with 404 error' do
    let(:resp) { client.entry('wordthatdoesnotexist') }
    it 'raises a 404 error when not found' do
      VCR.use_cassette('v1_entry_error') do
        expect(resp.error).to match(/No entry found/)
      end
    end
  end

  context '#entry with filters' do
    let(:resp_es) { client.entry('ace', lang: 'es') }
    let(:resp_sing_noun) do
      client.entry(
        'ace',
        grammaticalFeatures: %w(singular past), lexicalCategory: 'noun'
      )
    end

    it 'returns a spanish entry' do
      VCR.use_cassette('v1_entry_es') do
        expect_any_instance_of(OxfordDictionary::Request).
          to receive(:get).
          with(uri: URI("entries/es/ace")).
          once.
          and_call_original
        resp_es
      end
    end

    it 'returns a singular past noun entry' do
      VCR.use_cassette('v1_entry_past_nouns') do
        expect_any_instance_of(OxfordDictionary::Request).
          to receive(:get).
          with(uri: URI("entries/en-gb/ace?grammaticalFeatures=singular%2Cpast&lexicalCategory=noun")).
          once.
          and_call_original
        resp_sing_noun
      end
    end
  end

  context '#entry_definitions' do
    let(:resp) { client.entry_definitions('ace') }
    it 'has definition properties' do
      VCR.use_cassette('v1_entry_definitions') do
        expect_any_instance_of(OxfordDictionary::Request).
          to receive(:get).
          with(uri: URI("entries/en-gb/ace?fields=definitions")).
          once.
          and_call_original
        expect(resp.id).to eq('ace')
        resp
      end
    end
  end

  context '#entry_examples' do
    let(:resp) { client.entry_examples('ace') }
    it 'has example properties' do
      VCR.use_cassette('v1_entry_examples') do
        expect_any_instance_of(OxfordDictionary::Request).
          to receive(:get).
          with(uri: URI("entries/en-gb/ace?fields=examples")).
          once.
          and_call_original
        resp
        expect(resp.id).to eq('ace')
      end
    end
  end

  context '#entry_pronunciations' do
    let(:resp) { client.entry_pronunciations('ace') }
    it 'has pronunciation properties' do
      VCR.use_cassette('v1_entry_pronunciations') do
        expect_any_instance_of(OxfordDictionary::Request).
          to receive(:get).
          with(uri: URI("entries/en-gb/ace?fields=pronunciations")).
          once.
          and_call_original
        expect(resp.id).to eq('ace')
      end
    end
  end

  context '#entry_sentences' do
    let(:resp) { client.entry_sentences('vapid') }
    it 'has sentence properties' do
      VCR.use_cassette('v1_entry_sentences') do
        expect_any_instance_of(OxfordDictionary::Request).
          to receive(:get).
          with(uri: URI("sentences/en/vapid")).
          once.
          and_return(response_double)
        resp
      end
    end
  end

  context '#entry_antonyms' do
    let(:resp) { client.entry_antonyms('vapid') }
    it 'has antonym properties' do
      VCR.use_cassette('v1_entry_antonyms') do
        expect_any_instance_of(OxfordDictionary::Request).
          to receive(:get).
          with(uri: URI("thesaurus/en/vapid?fields=antonyms")).
          once.
          and_return(response_double)
        resp
      end
    end
  end

  context '#entry_synonyms' do
    let(:resp) { client.entry_synonyms('vapid') }
    it 'has synonym properties' do
      VCR.use_cassette('v1_entry_synonyms') do
        expect_any_instance_of(OxfordDictionary::Request).
          to receive(:get).
          with(uri: URI("thesaurus/en/vapid?fields=synonyms")).
          once.
          and_return(response_double)
        resp
      end
    end
  end

  context '#entry_antonyms_synonyms' do
    let(:resp) { client.entry_antonyms_synonyms('vapid') }
    it 'has both antonym and synonym properties' do
      VCR.use_cassette('v1_entry_antonym_synonym') do
        expect_any_instance_of(OxfordDictionary::Request).
          to receive(:get).
          with(uri: URI("thesaurus/en/vapid?fields=antonyms%2Csynonyms")).
          once.
          and_return(response_double)
        resp
      end
    end
  end

  context '#entry_translations' do
    let(:resp) { client.entry_translations('truth') }
    it 'has translation properties' do
      VCR.use_cassette('v1_entry_translations') do
        expect_any_instance_of(OxfordDictionary::Request).
          to receive(:get).
          with(uri: URI("translations/en-us/es/truth")).
          once.
          and_return(response_double)
        resp
        # expect(resp.id).to eq('truth')
      end
    end
  end
end
