class Account < ApplicationRecord
  belongs_to :user
  has_many :transactions

  validates :account_number, presence: true, uniqueness: true

  def credit!(amount)
    transaction_creator = TransactionCreator.new(self)
    transaction_creator.credit(amount)
  end
end
