class VideoSerializer
  include JSONAPI::Serializer
  attributes  :url, :video_id, :title, :source_type, :description, :embed_url, :created_at

  belongs_to :user
end
