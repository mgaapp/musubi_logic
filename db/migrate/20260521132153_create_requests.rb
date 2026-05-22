class CreateRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :requests do |t|
      t.integer :user_id, null: false
      t.integer :category_id, null: false
      t.integer :total_amount_incl_tax, null: false
      t.integer :unit_price_excl_tax, null: false
      t.integer :tax_rate, null: false
      t.integer :quantity, null: false
      t.string :vendor, null: false
      t.string :receipt_url, null: false
      t.string :status, null: false
      t.date :applied_at, null: false

      t.timestamps
    end
  end
end
