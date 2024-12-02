class CancelAbandonedCartsJob < ApplicationJob
  queue_as :default

  def perform
    carts_to_remove = Cart.where('last_interaction_at < ?', 7.days.ago).where(abandoned: true)
    carts_to_remove.each(&:remove_if_abandoned)
  end
end