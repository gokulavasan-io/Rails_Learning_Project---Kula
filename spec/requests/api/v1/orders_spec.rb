require 'rails_helper'

RSpec.describe 'Api::V1::Orders', type: :request do
  let!(:user) { create(:user) }
  let!(:order) { create(:order, user: user) }
  let!(:order_item) { create(:order_item, order: order) }
  let!(:product) {create(:product)}
  let(:headers) { auth_headers(user) }

  describe 'GET /api/v1/orders' do
    it 'returns a list of orders' do
      get "/api/v1/orders", headers: headers
      expect(response).to have_http_status(:success)
      expect(json_response.size).to eq(1)
    end
  end

  describe 'GET /api/v1/orders/:id' do
    context 'when order exists' do
      it 'returns the order details' do
        get "/api/v1/orders/#{order.id}", headers: headers
        expect(response).to have_http_status(:success)
        expect(json_response['id']).to eq(order.id)
      end
    end

    context 'when order does not exist' do
      it 'returns not found' do
        get "/api/v1/orders/9999", headers: headers
        expect(response).to have_http_status(:not_found)
        expect(json_response['error']).to eq('Order not found')
      end
    end
  end

  describe 'POST /api/v1/orders' do
    context 'when the order is valid' do
      it 'creates a new order' do
        order_params = { user_id: user.id, total_price: 100.0,order_items_attributes:[{product_id: product.id, quantity:5 }] }
        post "/api/v1/orders", params: { order: order_params }, headers: headers
        expect(response).to have_http_status(:created)
        expect(json_response['total_price'].to_f).to eq(100.0)
      end
    end

    context 'when the order is invalid' do
      it 'returns unprocessable entity with errors' do
        post "/api/v1/orders", params: { order: { user_id: nil, total_price: nil, order_items_attributes:[{product_id: product.id, quantity:5 }]}}, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['errors']).to include("User must exist", "Total price can't be blank")
      end
    end
  end

  describe 'PUT /api/v1/orders/:id' do
    context 'when the order exists and is valid' do
      it 'updates the order' do
        put "/api/v1/orders/#{order.id}", params: { order: { total_price: 150.0 } }, headers: headers
        expect(response).to have_http_status(:success)
        expect(json_response['total_price'].to_f).to eq(150.0)
      end
    end

    context 'when the order does not exist' do
      it 'returns not found' do
        put "/api/v1/orders/9999", params: { order: { total_price: 150.0 } }, headers: headers
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when the order is invalid' do
      it 'returns unprocessable entity with errors' do
        put "/api/v1/orders/#{order.id}", params: { order: { total_price: nil } }, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['errors']).to include("Total price can't be blank")
      end
    end
  end

  describe 'DELETE /api/v1/orders/:id' do
    context 'when the order exists' do
      it 'deletes the order' do
        delete "/api/v1/orders/#{order.id}", headers: headers
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when the order does not exist' do
      it 'returns not found' do
        delete "/api/v1/orders/9999", headers: headers
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  private

  def json_response
    JSON.parse(response.body)
  end
end
