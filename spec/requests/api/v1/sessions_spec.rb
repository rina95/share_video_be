require 'rails_helper'

RSpec.describe "Api::V1::Sessions", type: :request do
  describe "POST /create" do
    let!(:user) {create :user, email: "test@example.com", password: "123456" }
    
    context "when login success" do
      let(:params) do
        {
          user: {
            email: "test@example.com",
            password: "123456"
          }
        }
      end
      let(:json) do 
        {
          token: "123456",
          email: "test@example.com"
        }.to_json
      end
      before do
        allow(JsonWebToken).to receive(:encode).and_return "123456"
      end

      it "returns http success" do
        post "/api/v1/sessions/create", params: params

        expect(response).to have_http_status(:ok)
        expect(response.body).to eq(json)
        expect(response.status).to eq(200)
      end
    end

    context "when login fail" do
      let(:params) do
        {
          user: {
            email: "test@example.com",
            password: "333"
          }
        }
      end

      it "returns http success" do
        post "/api/v1/sessions/create", params: params

        expect(response).to have_http_status(401)
        expect(response.message).to eq("Unauthorized")
      end
    end
  end
end
