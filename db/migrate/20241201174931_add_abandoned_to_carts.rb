class AddAbandonedToCarts < ActiveRecord::Migration[7.1]
  def change
    add_column :carts, :abandoned, :boolean
  end
end
