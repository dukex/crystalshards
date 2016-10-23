require "./connection"

class Base
  include Connection
  extend Connection

  def self.many(defintion, query)
    puts "QUERY: #{query}"
    connection.exec(defintion, query).to_hash.map { |r| mapping r }
  end

  def self.one(defintion, query, id)
    puts "QUERY: #{query} [#{id}]"
    mapping connection.exec(defintion, query, [id]).to_hash.first
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
end
