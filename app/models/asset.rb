class Asset < ApplicationRecord
    belongs_to :request

    def depreciation_end_date
    return nil if purchase_date.blank? || useful_life_years.blank?

    purchase_date + useful_life_years.years
 end
end
