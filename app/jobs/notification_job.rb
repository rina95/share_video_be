class NotificationJob < ApplicationJob
  queue_as :default

  def perform(data)
    ActionCable.server.broadcast "notifications_video_shared", { data: data }
  end
end
