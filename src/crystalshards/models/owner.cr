module CrystalShards
  class Owner < Base
    def self.mapping(r)
      Owner.new r["id"], r["login"], r["avatar_url"]
    end

    @id : String
    @login : String
    @avatar_url : String

    getter :login, :avatar_url

    def initialize(@id, @login, @avatar_url)
    end
  end
end
