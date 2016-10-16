require "json"
require "html"

class GithubRepo
  JSON.mapping({
    name: { type: String },
    html_url: { type: String },
    description: { type: String, nilable: true },
    stargazers_count: { type: Int32 },
    owner: Owner,
    pushed_at: { type: Time, converter: Time::Format.new("%FT%TZ") },
    forks: { type: Int32 },
    private: { type: Bool },
  })

  def name
    HTML.escape @name
  end

  def html_url
    HTML.escape @html_url
  end

  def description
    if description = @description
      HTML.escape(Emoji.emojize(description))
    else
      nil
    end
  end

  struct Owner
    JSON.mapping({
      login: {type: String},
      avatar_url: {type: String},
    })

    def login
      HTML.escape @login
    end
  end
end
