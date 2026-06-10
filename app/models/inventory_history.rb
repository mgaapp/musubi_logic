class InventoryHistory < ApplicationRecord
  belongs_to :inventory
  belongs_to :user

  validates :quantity, presence: true
  validates :status,   presence: true

  enum status: { out: 0, fix: 1 }
end
