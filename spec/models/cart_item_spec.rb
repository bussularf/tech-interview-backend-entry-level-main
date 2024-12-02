require 'rails_helper'

RSpec.describe CartItem, type: :model do
  describe 'associations' do
    it 'belongs to a cart and product' do
      association_cart = described_class.reflect_on_association(:cart)
      association_product = described_class.reflect_on_association(:product)
      expect(association_cart.macro).to eq(:belongs_to)
      expect(association_product.macro).to eq(:belongs_to)
    end
  end

  describe 'validations' do
    it 'validates quantity is greater than 0' do
      cart_item = CartItem.new(quantity: -1)
      expect(cart_item).not_to be_valid
      expect(cart_item.errors[:quantity]).to include('must be greater than 0')
    end
  end
end
