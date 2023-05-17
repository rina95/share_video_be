class NotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "notifications_video_shared"
  end

  def unsubscribed
    stop_all_streams
  end
end
