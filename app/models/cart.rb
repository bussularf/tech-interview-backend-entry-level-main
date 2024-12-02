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

  def add_product(product, quantity)
    item = find_or_initialize_cart_item(product)
    update_item_quantity(item, quantity)
    recalculate_total_price
  end

  def update_product_quantity(product_id, quantity)
    item = cart_items.find_by!(product_id: product_id)
    update_item_quantity(item, quantity)
    recalculate_total_price
  end

  def remove_product(product_id)
    item =  cart_items.find_by!(product_id: product_id)
    item.destroy!
    recalculate_total_price
  end

  private

  def set_last_interaction_time
    self.last_interaction_at ||= Time.current
  end

  def find_or_initialize_cart_item(product)
    cart_items.find_or_initialize_by(product: product)
  end

  def update_item_quantity(item, quantity)
    item.update!(quantity: item.quantity + quantity)
  end

  def recalculate_total_price
    self.total_price = cart_items.includes(:product).sum { |item| item.product.price * item.quantity }
    save!
  end
end
