require "youtube/client"

class VideoService
  def initialize params = {}
    @params = params
    @url = params[:url]
  end

  attr_accessor :params, :url

  def create_video
    video = Video.new(params)
    return video if video.invalid?

    data = Youtube::Client.video_detail(video_id)
    if data.any?
      video_snippet = data["items"][0]["snippet"]
      video.assign_attributes(video_id: video_id, **video_snippet.slice("title", "description"))
      video.save
      notify_to_user(video)
    else
      video.errors.add(:url, "is invalid")
    end
    video
  rescue => ex
    video.errors.add(:url, "is invalid")
    video
  end

  private
  def video_id
    if url.include?("v=")
      uri = URI::parse(url)
      query_params = CGI.parse(uri.query)
      query_params["v"].first
    else
      url.gsub(/((http(s)?:\/\/)?)(www\.)?((youtube\.com\/)|(youtu.be\/))/, "")
    end
  end

  def notify_to_user video
    begin
      data = {user_name: video.user&.name, title: video.title}
      # ActionCable.server.broadcast "NotificationsChannel", { data: data }
      NotificationJob.perform_later(data)
    rescue => e 
      Rails.logger.error e.message
    end
  end
end
