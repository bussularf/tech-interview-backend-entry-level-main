class CartsController < ApplicationController
  before_action :set_cart, only: [:show, :add_item, :update_quantity, :remove_product]

  def create
    @cart = Cart.create!(total_price: 0.0)
    session[:cart_id] = @cart.id

    service = CartService.new(@cart)
    service.add_product(product_from_params, quantity_from_params)

    render_cart
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: "Error when creating cart: #{e.message}" }, status: :unprocessable_entity
  end

  def add_item
    handle_product_not_found do
      service = CartService.new(@cart)
      service.add_product(product_from_params, quantity_from_params)
      render_cart
    end
  end

  def update_quantity
    handle_product_not_found do
      service = CartService.new(@cart)
      service.update_product_quantity(params[:product_id], quantity_from_params)
      render_cart
    end
  end

  def remove_product
    handle_product_not_found do
      service = CartService.new(@cart)
      service.remove_product(params[:product_id])
      render_cart
    end
  end

  def show
    render_cart
  end

  private

  def set_cart
    @cart = Cart.find_or_create_by(id: params[:cart_id] || session[:cart_id])
  end

  def render_cart
    render json: cart_payload, status: :ok
  end

  def cart_payload
    {
      id: @cart.id,
      products: @cart.cart_items.map do |item|
        {
          id: item.product.id,
          name: item.product.name,
          quantity: item.quantity,
          unit_price: item.product.price.to_f,
          total_price: (item.product.price * item.quantity).to_f
        }
      end,
      total_price: @cart.total_price.to_f
    }
  end

  def product_from_params
    Product.find(params[:product_id])
  end

  def quantity_from_params
    params[:quantity].to_i
  end

  def handle_product_not_found
    yield
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Product not found in cart' }, status: :not_found
  end
end
