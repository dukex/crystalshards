module CrystalShards
  module Github
    class Client
      module Contents
        def readme(repo)
          contents repo, "readme"
        end

        def content(repo, path)
          get repo.contents_url.gsub("{+path}", path)
        end

        def content_exists?(repo, path)
          response = get repo.contents_url.gsub("{+path}", path)
          response.status_code == 200
        end
      end
    end
  end
end
