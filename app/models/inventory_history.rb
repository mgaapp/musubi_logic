class InventoryHistory < ApplicationRecord
  # 変更対象となる貯蔵品在庫データへの紐付け
  belongs_to :inventory
  # 操作・記録を行ったユーザーへの紐付け
  belongs_to :user

  # 変動数量およびステータスの必須チェック
  validates :quantity, presence: true
  validates :status, presence: true

  # 在庫変動の種類を管理
  enum :status, { out: 0, fix: 1 }
end
