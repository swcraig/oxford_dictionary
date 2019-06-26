require 'json'

module OxfordDictionary
  # A small service object that parses a JSON payload into
  # an OpenStruct recursively. The keys of the OpenStruct
  # are in camelCase, not snake_case. This keeps the struct
  # more representative of the JSON in the response.
  class Deserialize
    # Parses a JSON payload into an OpenStruct
    # Nested objects are also parsed into OpenStructs
    #
    # @param [String] payload a JSON string
    #
    # @return [OpenStruct] the JSON parsed into OpenStructs recursively
    def call(payload)
      JSON.parse(payload, object_class: OpenStruct)
    end
  end
end
