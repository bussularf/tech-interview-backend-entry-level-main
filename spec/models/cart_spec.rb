require 'rails_helper'

RSpec.describe Cart, type: :model do
  describe 'validations' do
    it 'validates numericality of total_price' do
      cart = described_class.new(total_price: -1)
      expect(cart.valid?).to be_falsey, "Expected cart to be invalid because total_price is negative"
      expect(cart.errors[:total_price]).to include("must be greater than or equal to 0")
    end
  end

  describe 'callbacks' do
    let(:cart) { build(:cart) }

    it 'sets last_interaction_at before save' do
      expect(cart.last_interaction_at).to be_nil
      cart.save!
      expect(cart.last_interaction_at).not_to be_nil
    end
  end

  describe 'scopes' do
    describe '.abandoned_longer_than' do
      let!(:abandoned_cart) { create(:cart, abandoned: true, last_interaction_at: 2.days.ago) }
      let!(:active_cart) { create(:cart, abandoned: false, last_interaction_at: 1.hour.ago) }

      it 'returns only carts abandoned longer than the specified duration' do
        expect(Cart.abandoned_longer_than(1.day)).to include(abandoned_cart)
        expect(Cart.abandoned_longer_than(1.day)).not_to include(active_cart)
      end
    end
  end

  describe '#mark_as_abandoned' do
    let(:cart) { create(:cart, last_interaction_at: 4.hours.ago) }

    it 'marks the cart as abandoned if inactive for more than 3 hours' do
      expect { cart.mark_as_abandoned }.to change { cart.abandoned? }.from(false).to(true)
    end

    it 'does not mark the cart as abandoned if recently active' do
      cart.update!(last_interaction_at: 1.hour.ago)
      expect { cart.mark_as_abandoned }.not_to change { cart.abandoned? }
    end
  end

  describe '#remove_if_abandoned' do
    let!(:cart) { create(:cart, abandoned: true, last_interaction_at: 8.days.ago) }

    it 'removes the cart if it is abandoned and inactive for more than 7 days' do
      expect { cart.remove_if_abandoned }.to change { Cart.count }.by(-1)
    end

    it 'does not remove the cart if it is not abandoned or inactive for less than 7 days' do
      cart.update!(abandoned: false, last_interaction_at: 6.days.ago)
      expect { cart.remove_if_abandoned }.not_to change { Cart.count }
    end
  end
end
