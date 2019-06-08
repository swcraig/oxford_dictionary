require 'net/http'

module OxfordDictionary
  class Request
    BASE_URL = 'https://od-api.oxforddictionaries.com/api/v2'.freeze

    def initialize(app_id:, app_key:)
      @app_id = app_id
      @app_key = app_key
    end

    def get(uri:)
      uri = URI("#{BASE_URL}/#{uri}")

      Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |https|
        https.request(request_object(uri))
      end
    end

    private

    def request_object(uri)
      Net::HTTP::Get.new(uri).tap do |request|
        request['Accept'] = 'application/json'
        request['app_id'] = @app_id
        request['app_key'] = @app_key
      end
    end
  end
end
