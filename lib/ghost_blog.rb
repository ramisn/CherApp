# frozen_string_literal: true

class GhostBlog
  LAST_3_POSTS_KEY = 'last 3 ghost posts'

  def self.fetch_posts(limit = 10)
    response = RestClient.get("#{ENV['BLOG_URL']}/ghost/api/v3/content/posts/",
                              params: { key: ENV['CHERBLOG_API_KEY'],
                                        limit: limit })
    return [] if response.code != 200

    json_response = JSON.parse(response.body)
    json_response['posts']
  rescue StandardError => _e
    []
  end

  def self.last_3_posts
    blogs = Redis.current.get(LAST_3_POSTS_KEY)
    return JSON.parse(blogs) unless blogs.blank?

    blogs = fetch_posts(3)
    # Make it expire in 24 hours
    Redis.current.set(LAST_3_POSTS_KEY, blogs.to_json, ex: 60 * 60 * 24) unless blogs.blank?
    blogs
  end
end
