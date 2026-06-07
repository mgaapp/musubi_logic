class ChangeReceiptUrlNullInRequests < ActiveRecord::Migration[8.0]
  def change
    change_column_null :requests, :receipt_url, true
  end
end
