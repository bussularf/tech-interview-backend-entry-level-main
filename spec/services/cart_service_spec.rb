require 'rails_helper'

RSpec.describe CartService, type: :service do
  let(:cart) { create(:cart) }
  let(:service) { described_class.new(cart) }
  let(:product) { create(:product, price: 10.0) }

  describe '#add_product' do
    it 'adds a product to the cart' do
      expect { service.add_product(product, 2) }.to change { cart.cart_items.count }.by(1)
      expect(cart.cart_items.last.quantity).to eq(2)
    end

    it 'updates the total price of the cart' do
      expect { service.add_product(product, 2) }.to change { cart.total_price }.from(0.0).to(20.0)
    end
  end

  describe '#update_product_quantity' do
    before { service.add_product(product, 2) }

    it 'updates the quantity of an existing product in the cart' do
      expect { service.update_product_quantity(product.id, 3) }.to change { cart.cart_items.last.quantity }.from(2).to(5)
    end

    it 'updates the total price of the cart' do
      expect { service.update_product_quantity(product.id, 3) }.to change { cart.total_price }.by(30.0)
    end
  end

  describe '#remove_product' do
    before { service.add_product(product, 2) }

    it 'removes the product from the cart' do
      expect { service.remove_product(product.id) }.to change { cart.cart_items.count }.by(-1)
    end

    it 'updates the total price of the cart' do
      expect { service.remove_product(product.id) }.to change { cart.total_price }.from(20.0).to(0.0)
    end
  end
end
