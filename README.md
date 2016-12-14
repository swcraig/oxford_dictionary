[![Build Status](https://travis-ci.org/swcraig/oxford-dictionary.svg?branch=master)](https://travis-ci.org/swcraig/oxford-dictionary)
[![Test Coverage](https://codeclimate.com/github/swcraig/oxford-dictionary/badges/coverage.svg)](https://codeclimate.com/github/swcraig/oxford-dictionary/coverage)
[![Code Climate](https://codeclimate.com/github/swcraig/oxford-dictionary/badges/gpa.svg)](https://codeclimate.com/github/swcraig/oxford-dictionary)
# OxfordDictionary

Ruby wrapper to consume the [Oxford Dictionary API](https://developer.oxforddictionaries.com/documentation)

## Getting Started

    $ gem install oxford_dictionary

    # To use in your script/application
    require 'oxford_dictionary'

After registering for an API key, setup the client:

    client = OxfordDictionary::Client.new(app_id: 'ID', app_key: 'SECRET')
    client = OxfordDictionary.new(app_id: 'ID', app_key: 'SECRET')

### Usage Examples
###### Get the results for an entry

    entry = client.entry('vapid')

    # With some filters
    filters = { lexicalCategory: 'Verb', domains: 'Art'}
    client.entry('truth', filters)

    # Or do them "inline"
    client.entry('truth', lexicalCategory: 'Verb', domains: 'Art')

    # From a dictionary of a specific language (default is 'en')
    client.entry('ace', lang: 'es')

###### Or return some subset of information

    # Like just the examples
    examples = client.entry_examples('explain')

    # Or only the pronunciations...
    the_noises = client.entry_pronunciations('knight')

    # Or some of the other documented API calls
    client.entry_sentences('scholar')
    client.entry_definitions('correct')
    client.entry_antonyms_synonyms('monotonous')
    # Etc...

    # Generally the method names follow the documented API closely

###### Other endpoint calls

    # Inflections of a word
    inflections = client.inflection('changed')

    # Wordlist results (based on categorys, filters, etc...)
    related = client.wordlist(lexicalCategory: 'Noun', word_length: '>5,<10')

    # Or the search endpoint
    search_results = client.search('condition', prefix: true)

###### A quick note on how to add filters to queries
There isn't much argument checking at the moment.  Some endpoints do not accept filter arguments, refer to the API documentation to check for endpoints that accept filters.  

    # All endpoints accept the :lang filter.  This specifies which dictionary to use
    # If no argument is supplied, default is 'en'
    filters = { lang: 'es' }

    # To use multiple values on a single filter, make it an array
    filters = { lexicalCategory: ['Noun', 'Verb'] }

    # The wordlist endpoint specifically may include "nested" filters
    # These filters (exclude, exclude_senses, etc...) require arrays
    filters = { exclude: [domains: %w(sport art)] }

Argument names need to be in camelCase, not snake_case. However, the objects returned from API calls use snake_case attributes.

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
