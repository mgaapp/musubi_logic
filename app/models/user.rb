class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :requests, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :name, presence: true
  validates :employee_number, presence: true, uniqueness: true
  validates :role, presence: true
  validates :password, presence: true, length: { minimum: 6 }, on: :create
  validates :password, length: { minimum: 6 }, allow_nil: true, on: :update
  enum :role, [:general, :admin]
end
