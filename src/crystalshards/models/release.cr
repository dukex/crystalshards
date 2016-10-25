module CrystalShards
  class Release < Base
    def self.mapping(r)
      Release.new id: ensure_string(r["id"]),
        name: ensure_string(r["name"]),
        tag_name: ensure_string(r["tag_name"]),
        body: ensure_string(r["body"]),
        published_at: ensure_time(r["published_at"]),
        draft: ensure_bool(r["draft"]),
        prerelease: ensure_bool(r["prerelease"]),
        html_url: ensure_string(r["html_url"])
    end

    @id : String
    @name : String
    @tag_name : String
    @body : String
    @published_at : Time
    @draft : Bool
    @prerelease : Bool
    @html_url : String

    getter :name, :tag_name, :body, :published_at, :draft, :prerelease, :html_url

    def initialize(@id, @name, @tag_name, @body, @published_at, @draft, @prerelease, @html_url)
    end
  end
end
