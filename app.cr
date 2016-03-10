require "kemal"
require "http/client"
require "emoji"
require "./views/index"
require "./models/github_repos"
require "./models/time_cache"

SORT_OPTIONS = {"stars", "updated", "forks"}
REPOS_CACHE = TimeCache(String, GithubRepos).new(30.minutes)
POPULAR_CACHE = TimeCache(String, GithubRepos).new(30.minutes)
RECENTLY_CACHE = TimeCache(String, GithubRepos).new(30.minutes)

def headers
  headers = HTTP::Headers.new
  headers["User-Agent"] = "crystalshards"
  headers
end

def crystal_repos(sort, page = 1, limit = 30)
  client = HTTP::Client.new("api.github.com", 443, true)
  response = client.get("/search/repositories?q=language:crystal&per_page=#{limit}&sort=#{sort}&page=#{page}", headers)
  GithubRepos.from_json(response.body)
end

def filter(repos, filter)
  filtered = repos.dup
  filtered.items.select! { |item| matches_filter?(item, filter) }
  filtered.total_count = filtered.items.size
  filtered
end

def fetch_sort(env)
  env.params.query["sort"]?.try(&.to_s) || ""
end

def fetch_filter(env)
  env.params.query["filter"]?.try(&.to_s.strip.downcase) || ""
end

def fetch_page(env)
  env.params.query["page"]?.try(&.to_i) || 0
end

private def matches_filter?(item : GithubRepo, filter : String)
  item.name.downcase.includes?(filter) ||
    item.description.try(&.downcase.includes? filter)
end

get "/" do |env|
  sort = fetch_sort(env)
  filter = fetch_filter(env)
	page = fetch_page(env)
  env.response.content_type = "text/html"

  repos = REPOS_CACHE.fetch(sort + "_" + page.to_s) { crystal_repos(sort, page) }
  popular = POPULAR_CACHE.fetch(sort) { crystal_repos(:stars, 1, 6) }
  recently = RECENTLY_CACHE.fetch(sort) { crystal_repos(:updated, 1, 6) }
  total = repos.not_nil!.total_count
  repos = filter(repos, filter) unless filter.empty?
  Views::Index.new total, repos, popular, recently, sort, filter, page
end

get "/:user/:repo" do |env|
  env.redirect("https://github.com/#{env.params.url["user"]}/#{env.params.url["repo"]}")
end
