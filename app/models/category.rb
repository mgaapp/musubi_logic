class Category < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :account_item, presence: true

  ACCOUNT_ITEMS = ["消耗品費", "貯蔵品", "通信費", "交通費"].freeze
end
