class Asset < ApplicationRecord
  # 申請が承認された際、資産データとの紐付け
  belongs_to :request

  # 購入年月日と耐用年数（年）から、資産の償却終了日を算出する
  def depreciation_end_date
    return nil if purchase_date.blank? || useful_life_years.blank?

    # 購入日に耐用年数を加算して償却終了日を計算
    purchase_date + useful_life_years.years
  end
end
