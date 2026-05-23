class Request < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_one :inventory, dependent: :destroy

  validates :user_id, presence: true
  validates :category_id, presence: true
  validates :total_amount_incl_tax, presence: true
  validates :unit_price_excl_tax, presence: true
  validates :tax_rate, presence: true
  validates :quantity, presence: true
  validates :vendor, presence: true
  validates :receipt_url, presence: true
  validates :status, presence: true
  validates :applied_at, presence: true
end
