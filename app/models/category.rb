class Category < ApplicationRecord
  # カテゴリ名：必須
  validates :name, presence: true, uniqueness: true
  # 勘定科目：必須
  validates :account_item, presence: true

  # 選択可能な勘定科目のリスト
  ACCOUNT_ITEMS = ["消耗品費", "貯蔵品", "通信費", "交通費"].freeze
end
