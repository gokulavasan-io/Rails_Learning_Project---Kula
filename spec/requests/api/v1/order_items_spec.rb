require 'rails_helper'

RSpec.describe 'Api::V1::OrderItems', type: :request do
  let!(:user) { create(:user) }
  let!(:product) { create(:product) }
  let!(:order) { create(:order, user: user) }
  let!(:order_item) { create(:order_item, order: order, product: product) }
  let(:headers) { auth_headers(user) }


  describe 'PUT /api/v1/order_items/:id' do
    it 'updates the quantity of the order item' do
      put "/api/v1/order_items/#{order_item.id}",
          params: { order_item: { quantity: 5 } },
          headers: headers

      expect(response).to have_http_status(:ok)
      expect(json_response["message"]).to eq("Order Item Updated successfully")
    end
  end

  describe 'DELETE /api/v1/order_items/:id' do
    it 'deletes the order item' do
      delete "/api/v1/order_items/#{order_item.id}", headers: headers

      expect(response).to have_http_status(:no_content)
      expect(OrderItem.exists?(order_item.id)).to be_falsey
    end

    it 'returns 404 if order_item does not exist' do
      delete "/api/v1/order_items/9999", headers: headers

      expect(response).to have_http_status(:not_found)
    end
  end

  def json_response
    JSON.parse(response.body)
  end
end
