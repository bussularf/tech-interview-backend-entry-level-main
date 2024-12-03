require 'rails_helper'

RSpec.describe "/carts", type: :request do
  describe "POST /add_items" do
    let(:cart) { Cart.create }
    let(:product) { Product.create(name: "Test Product", price: 10.0) }
    let!(:cart_item) { CartItem.create(cart: cart, product: product, quantity: 1) }

    context 'when the product already is in the cart' do
      subject do
        post '/cart/add_item', params: { cart_id: cart.id, product_id: product.id, quantity: 1 }, as: :json
        post '/cart/add_item', params: { cart_id: cart.id, product_id: product.id, quantity: 1 }, as: :json
      end

      it 'updates the quantity of the existing item in the cart' do
        expect { subject }.to change { cart_item.reload.quantity }.by(2)
      end
    end
  end

  describe 'POST /cart' do
  let(:product) { create(:product) }
  let(:cart) { create(:cart) }

    context 'when new product is added to cart' do
      it 'should add product to cart and return' do
        post '/cart', params: { product_id: product.id, quantity: 2 }, as: :json

        expect(response).to have_http_status(:ok)

        json_response = JSON.parse(response.body)

        expect(json_response['products']).to be_an(Array)
        expect(json_response['products'].first['id']).to eq(product.id)
        expect(json_response['products'].first['quantity']).to eq(2)
        expect(json_response['total_price']).to eq(20.0)
      end
    end
  end

  describe "GET /cart" do
    let(:cart) { create(:cart, total_price: 40.0) }
    let(:product1) { create(:product, name: "Produto 1", price: 10.0) }
    let(:product2) { create(:product, name: "Produto 2", price: 20.0) }
    let!(:cart_item1) { create(:cart_item, cart: cart, product: product1, quantity: 2) }
    let!(:cart_item2) { create(:cart_item, cart: cart, product: product2, quantity: 1) }

    before do
      allow_any_instance_of(CartsController).to receive(:session).and_return({ cart_id: cart.id })
    end

    it "return cart with all products and total price" do
      get "/cart", as: :json

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)

      expect(json_response['id']).to eq(cart.id)
      expect(json_response['products']).to match_array([
        a_hash_including('id' => product1.id, 'name' => 'Produto 1', 'quantity' => 2, 'unit_price' => 10.0, 'total_price' => 20.0),
        a_hash_including('id' => product2.id, 'name' => 'Produto 2', 'quantity' => 1, 'unit_price' => 20.0, 'total_price' => 20.0)
      ])      
      expect(json_response['total_price']).to eq(40.0)
    end
  end

  describe "PATCH /update_quantity" do
    let(:cart) { create(:cart) }
    let(:product) { create(:product) }
    let!(:cart_item) { create(:cart_item, cart: cart, product: product, quantity: 1) }

    context 'when the product is in the cart' do
      subject do
        patch '/cart/update_quantity', params: { cart_id: cart.id, product_id: product.id, quantity: 3 }, as: :json
      end

      it 'updates the quantity of the existing item in the cart' do
        expect { subject }.to change { cart_item.reload.quantity }.to(4)
      end

      it 'returns a successful response' do
        subject
        expect(response).to have_http_status(:ok)
      end

      it 'includes the updated total price in the response' do
        subject
        expect(JSON.parse(response.body)["total_price"]).to eq(40.0)
      end
    end

    context 'when the product is not in the cart' do
      it 'returns an error' do
        patch '/cart/update_quantity', params: { cart_id: cart.id, product_id: 99999, quantity: 3 }, as: :json
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)["error"]).to eq("Product not found in cart")
      end
    end
  end

  describe "DELETE /remove_product" do
    let(:cart) { create(:cart) }
    let(:product) { create(:product) }
    let!(:cart_item) { create(:cart_item, cart: cart, product: product, quantity: 1) }

    context 'when the product is in the cart' do
      subject do
        delete "/cart/#{product.id}", params: { cart_id: cart.id, product_id: product.id }, as: :json
      end

      it 'removes the product from the cart' do
        expect { subject }.to change { cart.cart_items.count }.by(-1)
      end

      it 'returns a successful response' do
        subject
        expect(response).to have_http_status(:ok)
      end

      it 'includes the updated total price in the response' do
        subject
        expect(JSON.parse(response.body)["total_price"]).to eq(0.0)
      end
    end

    context 'when the product is not in the cart' do
      it 'returns an error' do
        delete "/cart/99999", params: { cart_id: cart.id, product_id: 99999 }, as: :json
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)["error"]).to eq("Product not found in cart")
      end
    end
  end
end
