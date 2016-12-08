require 'spec_helper'

describe OxfordDictionary::Endpoints::EntryEndpoint do
  before do
    stub_get('entries/en/ace', 'entry_ace.json')
    stub_get('entries/es/ace', 'entry_ace_es.json')
    stub_get('entries/en/ace/regions=us', 'entry_ace_region_us.json')
    stub_get('entries/en/ace/definitions', 'entry_ace_definitions.json')
    stub_get('entries/en/ace/examples', 'entry_ace_examples.json')
    stub_get('entries/en/ace/pronunciations', 'entry_ace_pronunciations.json')
    stub_get('entries/en/vapid/sentences', 'entry_vapid_sentences.json')
    stub_get('entries/en/vapid/antonyms', 'entry_vapid_antonyms.json')
    stub_get('entries/en/vapid/synonyms', 'entry_vapid_synonyms.json')
    stub_get(
      'entries/en/wordthatdoesnotexist',
      'entry_error.json'
    ).to_return(status: 404)
    stub_get(
      'entries/en/truth/translations=es',
      'entry_truth_translations.json'
    )
    stub_get(
      'entries/en/ace/grammaticalFeatures=singular,past;lexical_category=noun',
      'entry_ace_singular_noun.json'
    )
    stub_get(
      'entries/en/vapid/synonyms;antonyms',
      'entry_vapid_antonym_synonym.json'
    )
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
      lex = resp.lexical_entries.first
      expect(lex.language).to eq('en')
      expect(lex.lexical_category).to eq('Noun')
      expect(lex.text).to eq('ace')
      expect(lex.entries).to be_an Array
    end

    it 'has an entry' do
      entry = resp.lexical_entries.first.entries.first
      expect(entry.homograph_number).to eq('000')
      expect(entry.etymologies).to be_an Array
      expect(entry.senses).to be_an Array
    end

    it 'has senses' do
      senses = resp.lexical_entries.first.entries.first.senses.first
      expect(senses.id).to eq('m_en_gb0004640.001')
    end

    it 'has a pronunciation' do
      pronunciation = resp.lexical_entries.first.pronunciations.first
      expect(pronunciation.phonetic_notation).to eq('IPA')
    end
  end

  context '#entry with 404 error' do
    it 'raises a 404 error when not found' do
      expect { client.entry('wordthatdoesnotexist') }.to raise_exception
    end
  end

  context '#entry with filters' do
    let(:resp_es) { client.entry('ace', lang: 'es') }
    let(:resp_region_us) { client.entry('ace', regions: 'us') }
    let(:resp_sing_noun) do
      client.entry(
        'ace',
        grammaticalFeatures: %w(singular past), lexical_category: 'noun'
      )
    end

    it 'returns a spanish entry' do
      expect(resp_es.id).to eq('ace')
      expect(resp_es.language).to eq('es')
    end

    it 'returns us region entry' do
      sense = resp_region_us.lexical_entries[0].entries.first.senses[0]
      expect(sense.id).to include('us')
    end

    it 'returns a singular noun entry' do
      expect(resp_sing_noun.lexical_entries.size).to eq(1)
    end
  end

  context '#entry_definitions' do
    let(:resp) { client.entry_definitions('ace') }
    it 'has definition properties' do
      expect(resp.id).to eq('ace')
      expect(resp.lexical_entries[0].pronunciations).to be_empty
      sense = resp.lexical_entries.first.entries.first.senses.first
      expect(sense.definitions).to be_an Array
    end
  end

  context '#entry_examples' do
    let(:resp) { client.entry_examples('ace') }
    it 'has example properties' do
      expect(resp.id).to eq('ace')
      expect(resp.lexical_entries[0].pronunciations).to be_empty
      sense = resp.lexical_entries.first.entries.first.senses.first
      expect(sense.examples).to be_an Array
    end
  end

  context '#entry_pronunciations' do
    let(:resp) { client.entry_pronunciations('ace') }
    it 'has pronunciation properties' do
      expect(resp.id).to eq('ace')
      expect(resp.lexical_entries[0].entries).to be_empty
    end
  end

  context '#entry_sentences' do
    let(:resp) { client.entry_sentences('vapid') }
    it 'has sentence properties' do
      expect(resp.id).to eq('vapid')
      expect(resp.lexical_entries[0].entries).to be_empty
      expect(resp.lexical_entries[0].sentences).to be_an Array
      expect(resp.lexical_entries[0].sentences[0].sense_ids).to be_an Array
    end
  end

  context '#entry_antonyms' do
    let(:resp) { client.entry_antonyms('vapid') }
    it 'has antonym properties' do
      expect(resp.id).to eq('vapid')
      entry = resp.lexical_entries[0].entries[0]
      expect(entry.senses[0].antonyms).to be_an Array
    end
  end

  context '#entry_synonyms' do
    let(:resp) { client.entry_synonyms('vapid') }
    it 'has synonym properties' do
      expect(resp.id).to eq('vapid')
      entry = resp.lexical_entries[0].entries[0]
      expect(entry.senses[0].synonyms).to be_an Array
    end
  end

  context '#entry_antonyms_synonyms' do
    let(:resp) { client.entry_antonyms_synonyms('vapid') }
    it 'has both antonym and synonym properties' do
      expect(resp.id).to eq('vapid')
      entry = resp.lexical_entries[0].entries[0]
      expect(entry.senses[0].antonyms).to be_an Array
      expect(entry.senses[0].antonyms[0].id).to eq('lively')
      expect(entry.senses[0].synonyms[0].id).to eq('insipid')
    end
  end

  context '#entry_translations' do
    let(:resp) { client.entry_translations('truth') }
    it 'has translation properties' do
      expect(resp.id).to eq('truth')
      expect(resp.language).to eq('en')
      entry = resp.lexical_entries[0].entries[0]
      expect(entry.senses[0].translations).to be_an Array
      expect(entry.senses[0].translations[0].language).to eq('es')
    end
  end
end
