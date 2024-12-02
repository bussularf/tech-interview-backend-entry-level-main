require 'rails_helper'

RSpec.describe MarkAbandonedCartsJob, type: :job do
  let!(:active_cart) { create(:cart, last_interaction_at: 1.hour.ago )}
  let!(:inactive_cart) { create(:cart, last_interaction_at: 4.hours.ago) }

  it 'marks carts as abandoned if they are inactive for more than 3 hours' do
    expect {
      described_class.perform_now
    }.to change { inactive_cart.reload.abandoned }.from(false).to(true)

    expect {
      described_class.perform_now
    }.not_to change { active_cart.reload.abandoned }
  end
end
