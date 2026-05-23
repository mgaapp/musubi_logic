class CreateInventories < ActiveRecord::Migration[8.0]
  def change
    create_table :inventories do |t|
      t.integer :request_id
      t.string :location
      t.integer :unit_price_excl_tax
      t.integer :stock_quantity
      t.string :vendor
      t.date :purchase_date
      t.string :status

      t.timestamps
    end
  end
end
