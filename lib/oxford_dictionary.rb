require 'oxford_dictionary/client'
require 'oxford_dictionary/version'

# Adds some aliasing
module OxfordDictionary
  class << self
    # Alias for OxfordDictionary::Client.new
    def new(params)
      Client.new(params)
    end
  end
end
