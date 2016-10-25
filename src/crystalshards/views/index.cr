require "ecr/macros"

module CrystalShards
  class Views::Index
    @repos_count : Int32
    @total_count : Int32
    @crystal_repos : Array(Shard)
    @trending_repos : Array(Shard)
    @popular_repos : Array(Shard)
    @recent_repos : Array(Shard)
    @page : Int32
    @sort : String
    @filter : String

    getter :trending_repos, :popular_repos, :recent_repos, :crystal_repos, :repos_count, :sort, :filter, :total_count, :page

    def initialize(total_repos, repos, trending, popular, recently, sort, filter, page)
      @repos_count = repos.size
      @crystal_repos = repos
      @trending_repos = trending
      @popular_repos = popular
      @recent_repos = recently
      @total_count = total_repos
      @page = page

      @sort = sort
      @filter = filter
      @now = Time.utc_now
    end

    def human_time(time)
      diff = (@now - time)
      if diff < 5.minutes
        "just now"
      elsif diff < 1.hour
        "#{diff.total_minutes.to_i} minutes ago"
      elsif diff < 2.hours
        "1 hour ago"
      elsif diff < 1.day
        "#{diff.total_hours.to_i} hours ago"
      elsif diff < 2.days
        "1 day ago"
      else
        "#{diff.total_days.to_i} days ago"
      end
    end

    ECR.def_to_s "./src/crystalshards/views/index.ecr"
  end
end
