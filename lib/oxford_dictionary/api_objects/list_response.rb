require 'virtus'

# Top level response (excluding metadata) from search and wordlist endpoints
class ListResponse
  include Virtus.model
  attribute :results, Array[OpenStruct]
end
