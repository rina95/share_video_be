require "rails_helper"

RSpec.describe "Api::V1::Videos", type: :request do
  describe "GET /index" do
    let(:params) { { page: 1, per_page: 2 }}
    let(:body) do 
      {
        data: data,
        links: links
      }.to_json
    end
    let(:links) do
      {
        first: 1,
        last: 0,
        prev: nil,
        next: nil,
      }
    end
    let(:data) { [] }

    context "when no data" do
      it "returns http success" do
        get "/api/v1/videos", params: params

        expect(response).to have_http_status(:ok)
        expect(response.body).to eq(body)
        expect(response.status).to eq(200)
      end
    end

    context "when have data" do
      let!(:video) {create :video }
      let(:links) do
        {
          first: 1,
          last: 1,
          prev: nil,
          next: nil,
        }
      end
      let(:body) do
        VideoSerializer.new([video], {links: links}).serializable_hash.to_json
      end

      it "returns http success" do
        get "/api/v1/videos", params: params

        expect(response).to have_http_status(:ok)
        expect(response.body).to eq(body)
        expect(response.status).to eq(200)
      end
    end


  end

  describe "POST /create" do
    let(:user) {create :user}

    context "when logged in" do
      before do
        allow_any_instance_of(Api::V1::VideosController).to receive(:current_user).and_return user
        allow_any_instance_of(Api::V1::VideosController).to receive(:video_params).and_return params
        allow(VideoService).to receive_message_chain(:new, :create_video)
          .with(params).with(no_args).and_return video
      end
      let(:params) do
        {
          video: {
            url: url
          }
        }
      end

      context "given valid params" do
        let(:video) { create :video }
        let(:url) { "https://www.youtube.com/watch?v=123456"}

        it "responds with created status" do
          post api_v1_videos_path, params: params

          expect(response).to have_http_status :created
        end
      end

      context "given invalid params" do
        let(:video) { OpenStruct.new(errors: OpenStruct.new(full_messages: ["URL is invalid"], any?: true))}
        let(:url) {"https://www.abc.com/watch?v=123456"}

        it "responds with unprocessable_entity status" do
          post api_v1_videos_path, params: params

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context "when not log in" do
      before do
        allow_any_instance_of(Api::V1::VideosController).to receive(:current_user).and_return nil
      end

      it "return forbidden" do
        post api_v1_videos_path, params: {url: ""}

        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
