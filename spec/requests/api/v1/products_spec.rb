require 'rails_helper'

RSpec.describe "Api::V1::Products", type: :request do
  let!(:user) { create(:user) }
  let!(:product1) { create(:product, name: "Product A", price: 100.0) }
  let!(:product2) { create(:product, name: "Product B", price: 200.0) }
  let(:headers) { auth_headers(user) }

  describe "GET /api/v1/products" do
    it "returns a list of products" do
      get "/api/v1/products", headers: headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(2)
    end
  end

  describe "GET /api/v1/products/:id" do
    it "returns a specific product" do
      get "/api/v1/products/#{product1.id}", headers: headers
      json = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(json["name"]).to eq("Product A")
    end
  end

  describe "POST /api/v1/products" do
    let(:valid_attributes) do
      { product: { name: "New Product", description: "Cool stuff", price: 99.99 } }
    end

    it "creates a new product" do
      expect {
        post "/api/v1/products", headers: headers, params: valid_attributes
      }.to change(Product, :count).by(1)

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)["name"]).to eq("New Product")
    end
  end

  describe "PUT /api/v1/products/:id" do
    let(:update_params) do
      { product: { name: "Updated Name", price: 150.0 } }
    end

    it "updates an existing product" do
      put "/api/v1/products/#{product1.id}", headers: headers, params: update_params
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["name"]).to eq("Updated Name")
    end
  end

  describe "DELETE /api/v1/products/:id" do
    it "deletes the product" do
      expect {
        delete "/api/v1/products/#{product1.id}", headers: headers
      }.to change(Product, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
