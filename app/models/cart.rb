class Cart < ApplicationRecord
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  validates :total_price, numericality: { greater_than_or_equal_to: 0 }

  scope :abandoned_longer_than, ->(duration) { where('last_interaction_at < ? AND abandoned = ?', duration.ago, true) }

  before_save :set_last_interaction_time

  def mark_as_abandoned
    return unless last_interaction_at < 3.hours.ago

    update!(abandoned: true)
  end

  def remove_if_abandoned
    return unless abandoned? && last_interaction_at < 7.days.ago

    destroy!
  end

  private

  def set_last_interaction_time
    self.last_interaction_at ||= Time.current
  end
end
