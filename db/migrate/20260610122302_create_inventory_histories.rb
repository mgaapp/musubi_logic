class CreateInventoryHistories < ActiveRecord::Migration[8.0]
  def change
    create_table :inventory_histories do |t|
      t.integer :inventory_id, null: false
      t.integer :user_id, null: false
      t.integer :quantity, null: false
      t.integer :status, null: false

      t.timestamps
    end
    add_index :inventory_histories, :inventory_id
    add_index :inventory_histories, :user_id
  end
end
