require 'net/http'
require 'json'
require_relative 'stats'
require_relative 'news'
require_relative 'news_loader'
require_relative 'mail_sender'

class Processing
  PAGES_TO_LOAD = 5
  attr_accessor :items, :stats
  def initialize(pages = nil)
    @pages = pages || PAGE_TO_LOAD
  end

  def process
    loader = NewsLoader.new
    news = (1..@pages).map { |i| loader.download_news i }.flatten.map {|news_hash| News.new(news_hash) }

    news_points = news.map(&:points)

    @stats = Stats.new news_points

    @items = news.select { |item| item.points > @stats.median }
    MailSender.send_success_mail(binding())
  rescue NewsLoader::Error
    MailSender.send_error_mail
  end
end
