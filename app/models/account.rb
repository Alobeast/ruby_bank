class Account < ApplicationRecord
  belongs_to :user
  has_many :transactions

  validates :account_number, presence: true, uniqueness: true
end
