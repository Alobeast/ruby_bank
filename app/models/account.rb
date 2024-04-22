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

  def transfer!(amount, counterpart_account)
    transaction_creator = TransactionCreator.new(self)
    errors = transaction_creator.transfer(amount, counterpart_account)
    if errors.empty?
      return true
    else
      errors.each { |error| self.errors.add(:base, error) }
      return false
    end
  end

  private

  def credit_sum
    transactions.credits.sum(:amount)
  end

  def debit_sum
    transactions.debits.sum(:amount)
  end
end
