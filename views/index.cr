require "ecr/macros"

class Views::Index
  getter :popular_repos, :recent_repos, :crystal_repos, :repos_count, :sort, :filter, :total_count

  def initialize(total_repos, repos, popular, recently, sort, filter)
    @repos_count = repos.total_count
    @crystal_repos = repos.items
    @popular_repos = popular.items
    @recent_repos = recently.items
    @total_count = total_repos

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

  ecr_file "./views/index.ecr"
end
