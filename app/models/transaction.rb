class Transaction < ApplicationRecord
  belongs_to :account
  belongs_to :counterpart_account, class_name: 'Account', optional: true

  validates :amount, presence: true
  validates :amount, numericality: {
    greater_than: 0, message: "must be greater than zero"
  }
  validates :transaction_type, presence: true

  enum transaction_type: {
    deposit: 0,
    withdrawal: 1,
    transfer_out: 2,
    transfer_in: 3
  }
end
