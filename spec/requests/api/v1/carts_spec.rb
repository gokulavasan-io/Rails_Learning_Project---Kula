require 'rails_helper'

RSpec.describe 'Api::V1::Carts', type: :request do
  let!(:user) { create(:user) }
  let!(:cart) { create(:cart, user: user) }
  let!(:product) { create(:product) }
  let(:headers) { auth_headers(user) }

  describe 'GET /api/v1/cart' do
    it 'returns the current user cart with cart items and products' do
      get '/api/v1/cart', headers: headers
      expect(response).to have_http_status(:ok)
      expect(json_response['cart_items']).to be_an(Array)
    end
  end

  describe 'POST /api/v1/cart/add' do
    context 'when product exists' do
      it 'adds the item to the cart' do
        post '/api/v1/cart/add', params: { product_id: product.id, quantity: 2 }, headers: headers
        expect(response).to have_http_status(:ok)
        expect(json_response['product_id']).to eq(product.id)
        expect(json_response['quantity']).to eq(2)
      end
    end

    context 'when product does not exist' do
      it 'returns not found' do
        post '/api/v1/cart/add', params: { product_id: 9999, quantity: 1 }, headers: headers
        expect(response).to have_http_status(:not_found)
        expect(json_response['error']).to eq('Product not found')
      end
    end
  end

  describe 'DELETE /api/v1/cart/remove' do
    let!(:cart_item) { create(:cart_item, cart: cart, product: product, quantity: 2) }

    context 'when item exists in cart' do
      it 'removes the item from the cart' do
        delete '/api/v1/cart/remove', params: { product_id: product.id }, headers: headers
        expect(response).to have_http_status(:ok)
        expect(json_response['message']).to eq('Item removed')
      end
    end

    context 'when item does not exist in cart' do
      it 'returns not found' do
        delete '/api/v1/cart/remove', params: { product_id: 9999 }, headers: headers
        expect(response).to have_http_status(:not_found)
        expect(json_response['error']).to eq('Item not found')
      end
    end
  end

  def json_response
    JSON.parse(response.body)
  end
end
