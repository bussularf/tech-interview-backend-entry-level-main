class CartService
  def initialize(cart)
    @cart = cart
  end

  def add_product(product, quantity)
    item = find_or_initialize_cart_item(product)
    update_item_quantity(item, quantity)
    recalculate_total_price
  end

  def update_product_quantity(product_id, quantity)
    item = @cart.cart_items.find_by!(product_id: product_id)
    update_item_quantity(item, quantity)
    recalculate_total_price
  end

  def remove_product(product_id)
    item = @cart.cart_items.find_by!(product_id: product_id)
    item.destroy!
    recalculate_total_price
  end

  private

  def find_or_initialize_cart_item(product)
    @cart.cart_items.find_or_initialize_by(product: product)
  end

  def update_item_quantity(item, quantity)
    item.update!(quantity: (item.quantity || 0) + quantity)
  end

  def recalculate_total_price
    @cart.total_price = @cart.cart_items.includes(:product).sum { |item| item.product.price * item.quantity }
    @cart.save!
  end
end
