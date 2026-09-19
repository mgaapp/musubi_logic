class User < ApplicationRecord
  # パスワードを暗号化して安全に保存・認証する機能
  has_secure_password

  # 1人のユーザーは複数の端末からログインできる
  has_many :sessions, dependent: :destroy
  # 1人のユーザーは複数の複数の申請データを作成できる
  has_many :requests, dependent: :destroy

  # メールアドレスの不要な空白を消し、すべて小文字に統一して保存する
  normalizes :email_address, with: ->(e) { e.strip.downcase }

  # 氏名：入力必須
  validates :name, presence: true
  # 社員番号：入力必須 ＆ 他の人と重複禁止
  validates :employee_number, presence: true, uniqueness: true
  # 権限（一般/管理者）：入力必須
  validates :role, presence: true
  # パスワード：新規作成時は必須 ＆ 6文字以上
  validates :password, presence: true, length: { minimum: 6 }, on: :create
  # パスワード：更新時
  validates :password, length: { minimum: 6 }, allow_nil: true, on: :update
  # ユーザーの役割
  enum :role, [:general, :admin]
end
