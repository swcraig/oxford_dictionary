[![Build Status](https://travis-ci.org/swcraig/oxford-dictionary.svg?branch=master)](https://travis-ci.org/swcraig/oxford-dictionary)
[![Test Coverage](https://codeclimate.com/github/swcraig/oxford-dictionary/badges/coverage.svg)](https://codeclimate.com/github/swcraig/oxford-dictionary/coverage)
[![Code Climate](https://codeclimate.com/github/swcraig/oxford-dictionary/badges/gpa.svg)](https://codeclimate.com/github/swcraig/oxford-dictionary)
[![Gem Version](https://badge.fury.io/rb/oxford_dictionary.svg)](https://badge.fury.io/rb/oxford_dictionary)
# OxfordDictionary

Ruby wrapper to consume the [Oxford Dictionary API](https://developer.oxforddictionaries.com/documentation)

## Getting Started

    $ gem install oxford_dictionary

    # To use in your script/application
    require 'oxford_dictionary'

After registering for an API key, setup the client:
```ruby
client = OxfordDictionary::Client.new(app_id: 'ID', app_key: 'SECRET')
client = OxfordDictionary.new(app_id: 'ID', app_key: 'SECRET')
```
### Usage Examples
This wrapper follows the schema laid out by the API quite closely. The data
schema for the different API calls can be found [here](https://developer.oxforddictionaries.com/documentation).

###### Entries
```ruby
entry = client.entry(word: 'vapid', dataset: 'en-gb', params: {})

# Access the first entry
# Refer to the API documentation for the schema of the returned data structure
first_lexical_entry = entry.lexicalEntries.first

# With some filters
filters = { lexicalCategory: 'Verb', domains: 'Art'}
client.entry(word: 'truth', dataset: 'en-gb', params: filters)

# You can also search for the results for different datasets
# Refer to the Oxford Dictionaries documentation for all the
# possible datasets
client.entry(word: 'ace', dataset: 'es', params: {})

# You can query for results from a specific "field"
# Refer to the Oxford Dictionaries documentation for all the
# possible fields
client.entry(word: 'explain', dataset: 'en-gb', params: { fields: 'examples' })

```

###### Lemmas
```ruby
client.lemma(word: 'condition', language: 'en', params: {})
```

###### Translations
```ruby
client.translation(
  word: 'condition',
  source_language: 'en',
  target_language: 'es',
  params: {}
)
```

###### Sentences
```ruby
client.sentence(word: 'paraphrase', language: 'en', params: {})
```

###### Search
```ruby
client.search(language: 'en-gb', params: { q: 'vapid' })
```

###### Thesaurus
```ruby
client.thesaurus(
  word: 'book',
  language: 'en',
  params: { fields: 'synonyms,antonyms}
)
# Or use { fields: 'synonyms' } for just synonyms
```

## Development

After checking out the repo, run `bin/setup` to install dependencies.
Run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are more than welcome!
Please make tests for anything that is added.
`bundle exec rake` will run rspec/rubocop.

#### Pull Requests
  - Read [this often cited resource on contributing to open source projects on GitHub](https://gun.io/blog/how-to-github-fork-branch-and-pull-request)
  - Fork the project
  - Code and commit in your own feature branch
  - Open a PR and nag me to close it!

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
