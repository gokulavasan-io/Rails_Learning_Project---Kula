require 'rails_helper'

RSpec.describe "Users API", type: :request do
  let!(:user) { create(:user) }

  describe "POST /api/v1/users" do
    it "creates a new user and returns a token" do
      post "/api/v1/users", params: {
        user: {
          name: "New User",
          email: "new@example.com",
          password: "password123"
        }
      }

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)).to include("token")
    end
  end

  describe "GET /api/v1/users/:id" do
    it "returns the user when authenticated" do
      get "/api/v1/users/#{user.id}", headers: auth_headers(user)


      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["email"]).to eq(user.email)
    end

    it "returns unauthorized without token" do
      get "/api/v1/users/#{user.id}"
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
