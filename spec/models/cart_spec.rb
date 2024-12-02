require 'rails_helper'

RSpec.describe Cart, type: :model do
  context 'when validating' do
    it 'validates numericality of total_price' do
      cart = described_class.new(total_price: -1)
      expect(cart.valid?).to be_falsey, "Expected cart to be invalid because total_price is negative"
      expect(cart.errors[:total_price]).to include("must be greater than or equal to 0")
    end
  end

  describe 'mark_as_abandoned' do
    let!(:cart) { create(:cart) }

    context 'when the cart is inactive for more than 3 hours' do
      it 'marks the shopping cart as abandoned' do
        cart.update(last_interaction_at: 4.hours.ago)
        expect { cart.mark_as_abandoned }.to change { cart.reload.abandoned? }.from(false).to(true)
      end
    end

    context 'when the cart is active and not inactive for long enough' do
      it 'does not mark the shopping cart as abandoned' do
        cart.update(last_interaction_at: Time.current)
        expect { cart.mark_as_abandoned }.not_to change { cart.reload.abandoned? }
      end
    end
  end

  describe 'remove_if_abandoned' do
    let!(:cart) { create(:cart, last_interaction_at: 7.days.ago) }

    context 'when the cart is marked as abandoned and inactive for more than 7 days' do
      it 'removes the shopping cart from the database' do
        cart.mark_as_abandoned
        expect { cart.remove_if_abandoned }.to change { Cart.count }.by(-1), "Expected cart to be destroyed after being abandoned for 7 days"
      end
    end

    context 'when the cart is not abandoned or not inactive for 7 days' do
      it 'does not remove the shopping cart from the database' do
        cart.update(last_interaction_at: 6.days.ago)
        expect { cart.remove_if_abandoned }.not_to change { Cart.count }, "Expected cart to remain in the database if not abandoned for 7 days"
      end
    end
  end
end
