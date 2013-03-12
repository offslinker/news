require 'uri'

class NewsLoader
  class Error < ::Exception

  end
  MAX_TRIES = 10
  PAGE_URL = "http://api.ihackernews.com/page"
  
  def download_news (try = MAX_TRIES)
    resp = Net::HTTP.get_response(uri)
    if resp.code == '200'
      result = JSON.parse(resp.body)
      @next_page = result['nextId']
      result['items']
    else
      raise NewsLoader::Error if try == 1
      download_news try-1
    end
  end

  private
  def uri
    @next_page.nil? ? URI(PAGE_URL) : URI("#{PAGE_URL}/#{@next_page}")
  end
end
