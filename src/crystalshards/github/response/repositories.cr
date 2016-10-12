require "json"
require "./base"

module CrystalShards
  module Github
    module Response
      class Repositories < Base
        JSON.mapping(
          total_count: Int32,
          incomplete_results: Bool,
          items: Array(Repository)
        )
      end

      class Repository
        JSON.mapping(
          id: Int32,
          name: String,
          full_name: String,
          # owner:{
          #   login:              "dtrupenn",
          #   id:                 872147,
          #   avatar_url:         "https://secure.gravatar.com/avatar/e7956084e75f239de85d3a31bc172ace?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png",
          #   gravatar_id:        "",
          #   url:                "https://api.github.com/users/dtrupenn",
          #   received_events_url:"https://api.github.com/users/dtrupenn/received_events",
          #   type:               "User",
          # },
          private: Bool,
          html_url: String,
          contents_url: String,
          description: String,
          fork: Bool,
          url: String,
          # created_at: "2012-01-01T00:31:50Z",
          # updated_at: "2013-01-05T17:58:47Z",
          # pushed_at: "2012-01-01T00:37:02Z",
          homepage: String?,
          size: Int32,
          stargazers_count: Int32,
          watchers_count: Int32,
          language: String,
          forks_count: Int32,
          open_issues_count: Int32,
          default_branch: String,
          score: Float32
        )
      end
    end
  end
end
