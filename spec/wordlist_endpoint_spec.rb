require 'spec_helper'

describe OxfordDictionary::Endpoints::WordlistEndpoint do
  before do
    stub_get('wordlist/en/registers=Rare;domains=Art', 'wordlist_rare_art.json')
    first_part = 'wordlist/en/lexicalCategory=Noun'
    second_part = 'exclude=domains=sport&word_length=>5,<10&prefix=goal'
    advanced = 'exclude=domains=sport,art;registers=informal'
    advanced_two = '&word_length=>5&prefix=goal'
    stub_get(
      "#{first_part}?#{second_part}&exact=false",
      'wordlist_goal_advanced.json'
    )
    stub_get(
      "#{first_part}?#{advanced}#{advanced_two}&exact=false",
      'wordlist_complex.json'
    )
  end
  let(:client) { OxfordDictionary.new(app_id: 'ID', app_key: 'SECRET') }

  context '#wordlist with basic filters' do
    let(:resp) { client.wordlist(registers: 'Rare', domains: 'Art') }
    it 'is a wordlist request' do
      expect(resp.results).to be_an Array
      expect(resp.results.size).to eq(3)
      expect(resp.results[0].word).to eq('eurhythmic')
    end
  end

  context '#wordlist with word length filter' do
    let(:resp) do
      client.wordlist(
        lexicalCategory: 'Noun',
        exclude: [domains: 'sport'],
        word_length: '>5,<10',
        prefix: 'goal'
      )
    end
    it 'is working as expected' do
      expect(resp.results).to be_an Array
      expect(resp.results.size).to eq(9)
      expect(resp.results[0].word).to eq('goal area')
    end
  end

  context '#wordlist with very complex filter' do
    let(:resp) do
      client.wordlist(
        lexicalCategory: 'Noun',
        exclude: [domains: %w(sport art), registers: 'informal'],
        word_length: '>5',
        prefix: 'goal'
      )
    end
    it 'is working as expected' do
      expect(resp.results).to be_an Array
      expect(resp.results.size).to eq(11)
      expect(resp.results[1].id).to eq('goal_average')
    end
  end
end
