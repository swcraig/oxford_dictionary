require 'json'

module OxfordDictionary
  class Deserialize
    def call(payload)
      JSON.parse(payload, object_class: OpenStruct)
    end
  end
end
