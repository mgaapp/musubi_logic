class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :name,presence: true
  validates :employee_number,presence: true, uniqueness: true
  validates :role,presence: true
  enum :role,[ :general, :admin ]
end
