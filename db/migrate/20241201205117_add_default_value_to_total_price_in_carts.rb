class AddDefaultValueToTotalPriceInCarts < ActiveRecord::Migration[7.1]
  def change
    change_column :carts, :total_price, :decimal, precision: 17, scale: 2, default: 0.0
  end
end
