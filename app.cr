require "kemal"
require "http/client"
require "json"
require "emoji"
require "./views/index"
require "./models/github_repos"
require "./models/time_cache"

SORT_OPTIONS = {"stars", "updated", "forks"}
REPOS_CACHE = TimeCache(String, GithubRepos).new(30.minutes)
ALL_REPOS_CACHE = TimeCache(String, GithubRepos).new(30.minutes)
POPULAR_CACHE = TimeCache(String, GithubRepos).new(30.minutes)
RECENTLY_CACHE = TimeCache(String, GithubRepos).new(30.minutes)

NAMES = JSON.parse(File.read("./misc/names.json"))

def headers
  headers = HTTP::Headers.new
  headers["User-Agent"] = "crystalshards"
  headers
end

def crystal_repos(word = "", sort = "stars", page = 1, limit = 100)
  client = HTTP::Client.new("api.github.com", 443, true)
  client.basic_auth ENV["GITHUB_USER"], ENV["GITHUB_KEY"]
  url = "/search/repositories?q=#{word.to_s != "" ? "#{word}+" : ""}language:crystal&per_page=#{limit}&sort=#{sort}&page=#{page}"
  response = client.get(url, headers)
  GithubRepos.from_json(response.body)
end

def fetch_sort(env)
  env.params.query["sort"]?.try(&.to_s) || ""
end

def fetch_filter(env)
  filter = env.params.query["filter"]?.try(&.to_s.strip.downcase) || ""
  filter.gsub(/\W/, "")
end

def fetch_page(env)
  env.params.query["page"]?.try(&.to_i) || 0
end

get "/" do |env|
  sort = fetch_sort(env)
  filter = fetch_filter(env)
	page = fetch_page(env)
  env.response.content_type = "text/html"

  repos = REPOS_CACHE.fetch(filter + "_" + sort + "_" + page.to_s) { crystal_repos(filter, sort, page) }
  all_repos = ALL_REPOS_CACHE.fetch("all") { crystal_repos("", sort, page) }
  popular = POPULAR_CACHE.fetch(sort) { crystal_repos("", :stars, 1, 8) }
  recently = RECENTLY_CACHE.fetch(sort) { crystal_repos("", :updated, 1, 6) }

  total = all_repos.not_nil!.total_count
  Views::Index.new total, repos, popular, recently, sort, filter, page
end

get "/name" do |env|
	random_name = NAMES.as_a.sample
  if env.request.headers["Accept"] == "*/*"
		random_name
	else
		render "views/name.ecr"
	end
end

get "/:user/:repo" do |env|
  env.redirect("https://github.com/#{env.params.url["user"]}/#{env.params.url["repo"]}")
end
