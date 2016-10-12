require "http/client"
require "./client/search"
require "./client/contents"

module CrystalShards
  module Github
    class Client
      ENDPOINT = "api.github.com"

      include Search
      include Contents

      def get(path)
        get(path, Hash(String, String).new)
      end

      def get(path, params : Hash(String, String))
        http.get(path + "?" + encode_params(params))
      end

      private def http
        HTTP::Client.new(ENDPOINT, 443, true)
      end

      private def encode_params(params)
        params.map do |k, v|
          "#{k}=#{v}"
        end.join("&")
      end
    end
  end
end
