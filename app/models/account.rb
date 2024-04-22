class Account < ApplicationRecord
  belongs_to :user
  has_many :transactions

  validates :account_number, presence: true, uniqueness: true

  def balance
    credit_sum - debit_sum
  end

  def credit!(amount)
    transaction_creator = TransactionCreator.new(self)
    transaction_creator.credit(amount)
  end

  private

  def credit_sum
    transactions.credits.sum(:amount)
  end

  def debit_sum
    transactions.debits.sum(:amount)
  end
end
