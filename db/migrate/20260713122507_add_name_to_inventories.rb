class AddNameToInventories < ActiveRecord::Migration[8.0]
  def change
    add_column :inventories, :name, :string
  end
end
