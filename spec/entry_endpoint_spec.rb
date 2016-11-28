require 'spec_helper'

describe OxfordDictionary::Endpoint::EntryEndpoint do
  before do
    stub_get('entries/en/ace/', 'basic_entry_ace.json')
    stub_get('entries/en/ace/definitions', 'entry_ace_definitions.json')
    stub_get('entries/en/ace/examples', 'entry_ace_examples.json')
    stub_get('entries/en/ace/pronunciations', 'entry_ace_pronunciations.json')
  end
  let(:client) { OxfordDictionary.new(app_id: 'ID', app_key: 'SECRET') }

  context '#entry without filters' do
    let(:resp) { client.entry('ace') }

    it 'is an entry request' do
      expect(resp.id).to eq('ace')
      expect(resp.language).to eq('en')
      expect(resp.word).to eq('ace')
    end

    it 'has a lexical entry' do
      lex = resp.lexicalEntries.first
      expect(lex.language).to eq('en')
      expect(lex.lexicalCategory).to eq('Noun')
      expect(lex.text).to eq('ace')
      expect(lex.entries).to be_an Array
    end

    it 'has an entry' do
      entry = resp.lexicalEntries.first.entries.first[1].first
      expect(entry.homographNumber).to eq('000')
      expect(entry.etymologies).to be_an Array
      expect(entry.senses).to be_an Array
    end

    it 'has senses' do
      senses = resp.lexicalEntries.first.entries.first[1].first.senses.first
      expect(senses.id).to eq('m_en_gb0004640.001')
    end

    it 'has a pronunciation' do
      pronunciation = resp.lexicalEntries.first.pronunciations.first
      expect(pronunciation.phoneticNotation).to eq('IPA')
    end
  end

  context '#entry with filters' do
  end

  context '#entry_definitions' do
    let(:resp) { client.entry_definitions('ace') }
    it 'has definition properties' do
      expect(resp.id).to eq('ace')
      expect(resp.lexicalEntries.first).not_to have_key('pronunciations')
      sense = resp.lexicalEntries.first.entries.first[1].first.senses.first
      expect(sense.definitions).to be_an Array
    end
  end

  context '#entry_examples' do
    let(:resp) { client.entry_examples('ace') }
    it 'has example properties' do
      expect(resp.id).to eq('ace')
      expect(resp.lexicalEntries.first).not_to have_key('pronunciations')
      sense = resp.lexicalEntries.first.entries.first[1].first.senses.first
      expect(sense.examples).to be_an Array
    end
  end

  context '#entry_pronunciations' do
    let(:resp) { client.entry_pronunciations('ace') }
    it 'has pronunciation properties' do
      expect(resp.id).to eq('ace')
      expect(resp.lexicalEntries.first).not_to have_key('entries')
    end
  end
end
