class Session < ApplicationRecord
  # このログイン情報は「どのユーザーのものか」を紐付ける
  belongs_to :user
end
