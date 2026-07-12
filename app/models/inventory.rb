class Inventory < ApplicationRecord
  belongs_to :request, optional: true
  has_many :inventory_histories, dependent: :destroy
  validates :stock_quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
