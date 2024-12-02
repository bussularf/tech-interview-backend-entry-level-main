class AddDefaultsToCarts < ActiveRecord::Migration[7.1]
  def change
    change_column_default :carts, :abandoned, from: nil, to: false
  end
end
