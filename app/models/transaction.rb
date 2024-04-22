class Transaction < ApplicationRecord
  belongs_to :account
  belongs_to :counterpart_account, class_name: 'Account', optional: true

  validates :amount, presence: true
  validates :amount, numericality: {
    greater_than: 0, message: "must be greater than zero"
  }
  validates :transaction_type, presence: true
  validate :balance_must_be_non_negative
  validate :sender_can_not_be_receiver


  scope :credits, -> { where(transaction_type: [:deposit, :transfer_in]) }
  scope :debits, -> { where(transaction_type: [:withdrawal, :transfer_out]) }

  enum transaction_type: {
    deposit: 0,
    withdrawal: 1,
    transfer_out: 2,
    transfer_in: 3
  }

  def balance_must_be_non_negative
    return unless withdrawal? || transfer_out?
    new_balance = account.balance - amount
    errors.add(:base, "Insufficient funds") if new_balance < 0
  end

  def sender_can_not_be_receiver
    if account_id == counterpart_account_id
      errors.add(:counterpart_account_id, "cannot be the same as the account_id")
    end
  end
end
