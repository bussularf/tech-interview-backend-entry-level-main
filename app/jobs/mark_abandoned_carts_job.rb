class MarkAbandonedCartsJob < ApplicationJob
  def perform
    carts = Cart.where('last_interaction_at <= ?', 3.hours.ago).where(abandoned: false)
    carts.find_each do |cart|
      cart.mark_as_abandoned
    end
  end
end
