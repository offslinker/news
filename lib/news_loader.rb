require 'uri'

class NewsLoader
  API_URI = URI("http://api.ihackernews.com/page")
  MAX_TRIES = 10

  def download_news (page = 1, try = MAX_TRIES)
    resp = Net::HTTP.get_response(API_URI)
    if resp.code == '200'
      JSON.parse(resp.body)['items']
    else
      raise NewsLoader::Error if try == 1
      download_news page,try-1
    end
  end

  class Error < ::Exception

  end
end
