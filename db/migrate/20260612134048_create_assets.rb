class CreateAssets < ActiveRecord::Migration[8.0]
  def change
    create_table :assets do |t|
      t.integer :request_id
      t.string :location
      t.integer :acquisition_cost_excl
      t.integer :useful_life_years
      t.string :depreciation_method
      t.date :service_start_date
      t.string :vendor
      t.date :purchase_date
      t.string :status

      t.timestamps
    end
  end
end
