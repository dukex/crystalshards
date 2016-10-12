require "../response/repositories"

module CrystalShards
  module Github
    class Client
      module Search
        def repositories(params)
          Response::Repositories.from_response search("repositories", params)
        end

        def search(path, params)
          get "/search/#{path}", params
        end
      end
    end
  end
end
