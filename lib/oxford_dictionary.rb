require 'oxford_dictionary/client'
require 'oxford_dictionary/error'
require 'oxford_dictionary/request'
require 'oxford_dictionary/version'
require 'oxford_dictionary/endpoints/entry_endpoint'
require 'oxford_dictionary/endpoints/inflection_endpoint'
require 'oxford_dictionary/endpoints/search_endpoint'
require 'oxford_dictionary/endpoints/wordlist_endpoint'

# Adds some aliasing
module OxfordDictionary
  class << self
    # Alias for OxfordDictionary::Client.new
    def new(params)
      Client.new(params)
    end
  end
end
