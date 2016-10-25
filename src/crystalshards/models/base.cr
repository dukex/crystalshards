require "./connection"

module CrystalShards
  class NotFound < Exception
  end

  class Base
    include Connection
    extend Connection

    def self.many(defintion, query)
      puts "QUERY: #{query}"
      connection.exec(defintion, query).to_hash.map { |r| mapping r }
    end

    def self.many(defintion, query, values)
      puts "QUERY: #{query} (#{values})"
      connection.exec(defintion, query, values).to_hash.map { |r| mapping r }
    end

    def self.one(defintion, query, id)
      puts "QUERY: #{query} [#{id}]"
      results = connection.exec(defintion, query, [id]).to_hash
      begin
        results.first
      rescue IndexError
        raise NotFound.new("Not found register with query #{query} [#{id}]")
      end

      mapping results.first
    end

    def self.ensure_time(value) : Time
      value.is_a?(Time) ? value : raise "#{value} is not a Time"
    end

    def self.ensure_string(value) : String
      value.is_a?(String) ? value : raise "#{value} is not a String"
    end

    def self.ensure_integer(value) : Int32
      value.is_a?(Int32) ? value : raise "#{value} is not a Int32"
    end

    def self.ensure_bool(value) : Bool
      value.is_a?(Bool) ? value : raise "#{value} is not a Boolean"
    end
  end
end
