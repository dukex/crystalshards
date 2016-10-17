require "pg"
require "github"

client = Github::Client.new access_token: ENV.fetch("ACCESS_TOKEN")

class Connection
  def self.connection
    @@current_connetion ||= PG.connect ENV.fetch("DATABASE_URL")
  end
end

connection = Connection.connection

def create_or_update(github_id, table, fields, values, data)
  connection = Connection.connection

  exists = connection.exec({String}, "SELECT id FROM #{table} WHERE github_id=$1 LIMIT 1", [github_id]).rows.size > 0

  if exists
    connection.exec(%{
    UPDATE #{table}
      SET #{fields.split(",").zip(values.split(",")).to_h.map { |k, v| "#{k} = #{v}" }.join(",")}
      WHERE github_id = $1;
    }, data)

    puts "+ #{data} in #{table} updated"
  else
    connection.exec(%{
      INSERT INTO #{table} (
        #{fields}
      ) VALUES (
        #{values}
      )
    }, data)

    puts "+ #{data} in #{table} saved"
  end
end

def save(repositories, client)
  repositories.each do |r|
    begin
      client.content(r, "shard.yml")

      owner = r.owner

      create_or_update(
        r.id,
        "shards",
        "github_id, name, full_name, description, watchers_count, stargazers_count, url, html_url, homepage, owner_github_id, pushed_at, updated_at",
        "$1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12",
        [r.id, r.name, r.full_name, r.description, r.watchers_count, r.stargazers_count, r.url, r.html_url, r.homepage || "", owner.id, r.pushed_at, Time.now]
      )

      create_or_update(
        owner.id,
        "owners",
        "github_id, login, avatar_url, html_url, type",
        "$1, $2, $3, $4, $5",
        [owner.id, owner.login, owner.avatar_url, owner.html_url, owner.type]
      )
    rescue e : PQ::PQError
      puts e
      puts "============="
    rescue Github::Error::NotFound
      puts "- no found shard.yml in #{r.name} (#{r.html_url})"
    end
  end
end

repositories = client.repositories({"q" => "language:crystal"})

pages = (repositories.total_count / repositories.items.size)
pages_rows = connection.exec({Int32}, "SELECT page FROM checker ORDER BY created_at DESC LIMIT 1").rows
initial_page = (pages_rows.size > 0 ? pages_rows.first.first : 0) + 1

(initial_page..pages).each do |page|
  repositories = client.repositories({"q" => "language:crystal", "page" => page.to_s})
  save(repositories.items, client, connection)

  connection.exec(%{INSERT INTO checker (page) VALUES ($1)}, [5])
end

connection.close
