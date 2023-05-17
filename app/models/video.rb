class Video < ApplicationRecord
  belongs_to :user

  validates :url, presence: true, uniqueness: true, format: {
    with: /((http(s)?:\/\/)?)(www\.)?((youtube\.com\/)|(youtu.be\/))[\S]+/, message: "is invalid"
  }

  def embed_url
    "https://www.youtube.com/embed/" + video_id
  end
end
