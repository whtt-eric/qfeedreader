class Feed < ActiveRecord::Base
  has_many :posts

  after_create :fetch

  def fetch
    Delayed::Job.enqueue self
  end

  def perform
    feed = FeedTools::Feed.open(url)

    transaction do
      self.title = feed.title
      self.updated_at = Time.now
      save!

      feed.items.slice(0, 3).each do |item|
        unless posts.find_by_url(item.link)
          posts.create! :title => item.title, :url => item.link
        end
      end
    end
  end

  def after_perform
    Juggernaut.send_to_client("update_feed('#{id}')", 1)
  end

  def self.fetch_all
    all.each do |feed|
      feed.fetch
    end
  end
end
