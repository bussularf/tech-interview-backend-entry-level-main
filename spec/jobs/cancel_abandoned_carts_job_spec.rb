require 'rails_helper'

RSpec.describe CancelAbandonedCartsJob, type: :job do
  let!(:recent_cart) { create(:cart, abandoned: true, last_interaction_at: 6.days.ago) }
  let!(:old_cart) { create(:cart, abandoned: true, last_interaction_at: 8.days.ago) }

  it 'removes carts abandoned for more than 7 days' do
    expect {
      described_class.perform_now
    }.to change { Cart.count }.by(-1)

    expect(Cart.exists?(old_cart.id)).to be_falsey
    expect(Cart.exists?(recent_cart.id)).to be_truthy
  end
end
