require "./base"
require "./owner"
require "./release"

module CrystalShards
  class Shard < Base
    def self.mapping(r)
      Shard.new id: ensure_string(r["id"]),
        name: ensure_string(r["name"]),
        description: ensure_string(r["description"]),
        stargazers_count: ensure_integer(r["stargazers_count"]),
        html_url: ensure_string(r["html_url"]),
        full_name: ensure_string(r["full_name"]),
        pushed_at: ensure_time(r["pushed_at"]),
        owner_id: ensure_integer(r["owner_github_id"]),
        github_id: ensure_integer(r["github_id"])
    end

    @id : String
    @name : String
    @description : String
    @stargazers_count : Int32
    @html_url : String
    @full_name : String
    @pushed_at : Time
    @owner : Owner
    @releases : Array(Release)

    getter :name, :description, :stargazers_count, :html_url, :full_name, :owner, :pushed_at, :releases

    def initialize(@id, @name, @description, @stargazers_count, @html_url, @full_name, @pushed_at, owner_id, github_id)
      @owner = Owner.one({String, String, String}, "SELECT id, login, avatar_url FROM owners WHERE github_id=$1 LIMIT 1", owner_id)

      @releases = Release.many({String, String, String, String, Time, Bool, Bool, String}, "SELECT id, name, tag_name, body, published_at, draft, prerelease, html_url FROM releases WHERE repo_github_id=$1", [github_id])
    end
  end
end
