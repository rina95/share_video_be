class Api::V1::VideosController < ApplicationController
  include Paginable

  before_action :check_login, only: %i[create]

  def index
    @videos = Video.includes(:user).page(params[:page]).per(params[:per_page])
    options = {
      links: {
        first: api_v1_videos_path(page: 1),
        last: api_v1_videos_path(page: @videos.total_pages),
        prev: api_v1_videos_path(page: @videos.prev_page),
        next: api_v1_videos_path(page: @videos.next_page),
      },
      include: [:user]
    }

    render json: VideoSerializer.new(@videos, options).serializable_hash.to_json
  end

  def create
    @video = VideoService.new(video_params).create_video
    if @video.errors.any?
      render json: { errors: @video.errors }, status: :unprocessable_entity
    else
      render json: VideoSerializer.new(@video).serializable_hash.to_json, status: :created
    end
  end

  private
  def video_params
    params.require(:video).permit(:url).tap do |param|
      param[:user_id] = @current_user.id
    end
  end
end
