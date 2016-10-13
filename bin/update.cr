require "../src/crystalshards"
require "pg"
require "github"

connection = PG.connect ENV.fetch("DATABASE_URL")
client = Github::Client.new access_token: ENV.fetch("ACCESS_TOKEN")

def save(repositories, client, connection)
  repositories.each do |r|
    begin
      client.content(r, "shard.yml")

      connection.exec(%{
      INSERT INTO shards (
        github_id,
        name,
        full_name,
        description,
        watchers_count,
        stargazers_count,
        url,
        homepage
      ) VALUES (
        $1, $2, $3, $4, $5, $6, $7, $8
      )
    }, [r.id, r.name, r.full_name, r.description, r.watchers_count, r.stargazers_count, r.url, r.homepage || ""])
      "+ #{r.name} saved"
    rescue PQ::PQError
      puts "+ shard #{r.name} exists"
    rescue Github::NotFound
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
