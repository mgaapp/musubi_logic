class ChangeColumnToBigInt < ActiveRecord::Migration[8.0]
  def change
    change_column :sessions, :user_id, :bigint
  end
end
