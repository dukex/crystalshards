require "ecr/macros"

module CrystalShards
  class Views::Show
    @shard : Shard

    getter :shard

    def initialize(shard)
      @shard = shard
    end

    def how_to_use
      "(" + shard.releases.inspect + ")" + shard.inspect
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

    ECR.def_to_s "./src/crystalshards/views/show.ecr"
  end
end
