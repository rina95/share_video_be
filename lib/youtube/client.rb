require "net/http"

module Youtube
  class Client
    API_KEY = ENV["YOUTUBE_API_KEY"]
    BASE_URL = "https://www.googleapis.com/youtube/v3"

    class << self
      def video_detail(id)
        params = {
          id: id,
          key: API_KEY,
          part: "snippet,status"
        }
        url = "%s/%s?%s" % [BASE_URL, "videos", params.to_query]
        uri = URI.parse(url)
        res = Net::HTTP.get_response(uri)

        if http_success?(res)
          JSON.parse(res.body)
        else
          {}
        end
      rescue => e
        Rails.logger.error("[#{self.class}.#{__method__}] error: #{e.message}")
        {}
      end

      private
      def http_success?(res)
        res.instance_of?(Net::HTTPOK)
      end
    end
  end
end
