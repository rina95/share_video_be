require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  describe "POST /create" do
    context "given valid params" do
      let(:params) do
        {
          user: {
            name: "test",
            password: "123456",
            email: "test@mail.com"
          }
        }
      end

      it "responds with created status" do
        post api_v1_users_path, params: params

        expect(response).to have_http_status :created
        expect(JSON.parse(response.body)["data"]["attributes"]["email"]).to eq "test@mail.com"
        expect(response.status).to eq(201)
      end
    end

    context "given invalid params" do
      let(:params) do
        {
          user: {
            name: "test",
            password: "",
            email: "test@mail.com"
          }
        }
      end

      it "responds with unprocessable_entity status" do
        post api_v1_users_path, params: params

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
