module CrystalShards
  module Connection
    def connection
      @@current_connection ||= PG.connect(ENV.fetch("DATABASE_URL"))
    end
  end
end
