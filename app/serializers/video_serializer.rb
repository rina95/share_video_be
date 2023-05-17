class VideoSerializer
  include JSONAPI::Serializer
  attributes :id, :url, :video_id, :title, :description, :embed_url, :created_at

  set_type :video

  attribute :user_id do |video|
    video.user&.id
  end

  attribute :user_name do |video|
    video.user&.name
  end
end
