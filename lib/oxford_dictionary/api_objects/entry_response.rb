require 'virtus'
require 'oxford_dictionary/api_objects/lexical_entry'

# Top level response (excluding metadata) from entries endpoints
class EntryResponse
  include Virtus.model
  attribute :id, String
  attribute :language, String
  attribute :type, String
  attribute :word, String
  attribute :lexical_entries, Array[LexicalEntry]
end
