require 'rails_helper'

RSpec.describe 'Api::V1::OrderItems', type: :request do
  let!(:user) { create(:user) }
  let!(:order) { create(:order, user: user) }
  let!(:product) { create(:product) }
  let!(:order_item) { create(:order_item, order: order, product: product) }
  let(:headers) { auth_headers(user) }

  describe 'POST /api/v1/order_items' do
    context 'with valid parameters' do
      it 'creates an order item' do
        params = { order_item: { order_id: order.id, product_id: product.id, quantity: 2 } }
        post '/api/v1/order_items', params: params, headers: headers

        expect(response).to have_http_status(:created)
        expect(json_response['order_id']).to eq(order.id)
        expect(json_response['product_id']).to eq(product.id)
        expect(json_response['quantity']).to eq(2)
      end
    end

    context 'with invalid parameters' do
      it 'returns unprocessable entity' do
        post '/api/v1/order_items', params: { order_item: { order_id: nil, product_id: nil } }, headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response).to have_key('order')
        expect(json_response).to have_key('product')
      end
    end
  end

  describe 'PUT /api/v1/order_items/:id' do
    context 'when order_item exists and params are valid' do
      it 'updates the order item' do
        put "/api/v1/order_items/#{order_item.id}", params: { order_item: { quantity: 5 } }, headers: headers

        expect(response).to have_http_status(:ok)
        expect(json_response['quantity']).to eq(5)
      end
    end

    context 'when order_item is invalid' do
      it 'returns unprocessable entity' do
        put "/api/v1/order_items/#{order_item.id}", params: { order_item: { quantity: nil } }, headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['errors']).to include("Quantity can't be blank")
      end
    end
  end

  describe 'DELETE /api/v1/order_items/:id' do
    context 'when order_item exists' do
      it 'deletes the order item' do
        delete "/api/v1/order_items/#{order_item.id}", headers: headers
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when order_item does not exist' do
      it 'returns not found' do
        delete "/api/v1/order_items/9999", headers: headers
        expect(response).to have_http_status(:not_found)
        expect(json_response['errors']).to include("Couldn't find OrderItem with 'id'=9999")
      end
    end
  end

  private

  def json_response
    JSON.parse(response.body)
  end
end
