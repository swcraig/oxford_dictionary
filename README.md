
[![Build Status](https://travis-ci.org/swcraig/oxford-dictionary.svg?branch=master)](https://travis-ci.org/swcraig/oxford-dictionary)
[![Test Coverage](https://codeclimate.com/github/swcraig/oxford-dictionary/badges/coverage.svg)](https://codeclimate.com/github/swcraig/oxford-dictionary/coverage)
[![Code Climate](https://codeclimate.com/github/swcraig/oxford-dictionary/badges/gpa.svg)](https://codeclimate.com/github/swcraig/oxford-dictionary)
# OxfordDictionary

Ruby wrapper to consume the [Oxford Dictionary](https://developer.oxforddictionaries.com/documentation) API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'oxford_dictionary'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install oxford_dictionary

## Usage

Make an API key...

Setup the client:

```
client = OxfordDictionary::Client.new()
client = OxfordDictionary.new()
```


## Examples
##### Find entry
```
client.entry("ace")
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/swcraig/oxford_dictionary. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
