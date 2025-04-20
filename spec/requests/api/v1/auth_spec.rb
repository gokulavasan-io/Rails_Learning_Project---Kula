require 'rails_helper'

RSpec.describe "Auth API", type: :request do
  let!(:user) { create(:user, password: "password123") }

  describe "POST /api/v1/login" do
    it "returns token with valid credentials" do
      post "/api/v1/login", params: {
        email: user.email,
        password: "password123"
      }

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json).to include("token")
      expect(json["user"]["email"]).to eq(user.email)
    end

    it "returns unauthorized with invalid credentials" do
      post "/api/v1/login", params: {
        email: user.email,
        password: "wrongpassword"
      }

      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)).to include("error")
    end
  end
end
