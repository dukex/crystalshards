require "../src/crystalshards"
require "pg"

connection = PG.connect ENV.fetch("DATABASE_URL")

client = CrystalShards::Github::Client.new

repositories = client.repositories({"q" => "language:crystal"}).items
repositories.each do |r|
  if client.content_exists?(r, "shard.yml")
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
  else
    puts "==== #{r.name} ==="
    puts "Score: #{r.score}"
    puts "Stars: #{r.stargazers_count}"
    puts "URL: #{r.html_url}"
    puts "------------------"
  end
end
