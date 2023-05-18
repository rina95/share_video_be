class Api::V1::VideosController < ApplicationController
  include Paginable

  before_action :check_login, only: %i[create]

  def index
    @videos = Video.includes(:user).page(params[:page]).per(params[:per_page])
    options = {
      links: {
        first: 1,
        last: @videos.total_pages,
        prev: @videos.prev_page,
        next: @videos.next_page,
      }
    }

    render json: VideoSerializer.new(@videos, options).serializable_hash.to_json
  end

  def create
    @video = VideoService.new(video_params).create_video
    if @video.errors.any?
      render json: { messages: @video.errors.full_messages }, status: :unprocessable_entity
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
