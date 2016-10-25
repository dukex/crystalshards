require "kemal"
require "http/client"
require "json"
require "pg"
require "emoji"
require "./views/index"
require "./models/time_cache"
require "./models/shard"

module CrystalShards
  class App
    SORT_OPTIONS    = {"stargazers_count", "pushed_at", "forks"}
    REPOS_CACHE     = TimeCache(String, Array(Shard)).new(30.minutes)
    ALL_REPOS_CACHE = TimeCache(String, Array(Shard)).new(30.minutes)
    TRENDING_CACHE  = TimeCache(String, Array(Shard)).new(30.minutes)
    POPULAR_CACHE   = TimeCache(String, Array(Shard)).new(30.minutes)
    RECENTLY_CACHE  = TimeCache(String, Array(Shard)).new(30.minutes)

    NAMES = JSON.parse(File.read("./db/names.json"))

    def initialize
    end

    def self.run
      new.run
    end

    def headers
      headers = HTTP::Headers.new
      headers["User-Agent"] = "crystalshards"
      headers
    end

    def crystal_repos(sort = "stargazers_count", page = 1, limit = nil, after_date = nil)
      order_by = sort.empty? ? "" : "ORDER BY #{sort} DESC"
      limit_query = limit.nil? ? "" : "LIMIT #{limit} OFFSET #{(1 - page) * limit}"
      pushed_at_query = after_date.nil? ? "" : "pushed_at::timestamp > '#{after_date}'::timestamp"
      where = pushed_at_query.empty? ? "" : "WHERE #{pushed_at_query}"

      Shard.many(
        {String, String, String, Int32, String, String, Time, Int32},
        "SELECT id, name, description, stargazers_count, html_url, full_name, pushed_at, owner_github_id FROM shards #{where} #{order_by} #{limit_query}"
      )
    end

    def fetch_sort(env)
      env.params.query["sort"]?.try(&.to_s) || ""
    end

    def fetch_filter(env)
      filter = env.params.query["filter"]?.try(&.to_s.strip.downcase) || ""
      filter.gsub(/[^a-z0-9\_\-]/i, "")
    end

    def fetch_page(env)
      env.params.query["page"]?.try(&.to_i) || 1
    end

    def main(env, query = "")
      sort = fetch_sort(env)
      filter = fetch_filter(env)
      page = fetch_page(env)
      env.response.content_type = "text/html"

      repos = REPOS_CACHE.fetch("repos" + sort + page.to_s) { crystal_repos sort: sort, page: page }
      all_repos = ALL_REPOS_CACHE.fetch("all" + sort + page.to_s) { crystal_repos }
      trending = TRENDING_CACHE.fetch("trending" + page.to_s) { crystal_repos limit: 10, page: page, after_date: 1.weeks.ago }
      popular = POPULAR_CACHE.fetch("popular" + page.to_s) { crystal_repos limit: 8, page: page }
      recently = RECENTLY_CACHE.fetch("recently" + page.to_s) { crystal_repos sort: "pushed_at", page: 1, limit: 6 }

      Views::Index.new sort: sort,
        filter: filter,
        page: page,
        trending: trending,
        popular: popular,
        recently: recently,
        repos: repos,
        total_repos: all_repos.size
    end

    def run
      get "/" do |env|
        main env
      end

      get "/name" do |env|
        random_name = NAMES.as_a.sample
        if env.request.headers["Accept"] == "*/*"
          random_name
        else
          render "src/crystalshards/views/name.ecr"
        end
      end

      # get "/:user" do |env|
      #   main env, "user:#{env.params.url["user"]}"
      # end

      # get "/:user/:repo" do |env|
      #   env.redirect("https://github.com/#{env.params.url["user"]}/#{env.params.url["repo"]}")
      # end

      Kemal.run
    end
  end
end
