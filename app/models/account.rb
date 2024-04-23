class Account < ApplicationRecord
  belongs_to :user
  has_many :transactions

  validates :account_number, presence: true, uniqueness: true

  def balance(date=Date.today)
    credit_sum(date) - debit_sum(date)
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

  # returns the account balance, credit, debit and transactions at a given date
  # given date is format DD-MM-YY to allow requesting balance via console
  def balance_history(date)
    begin
      end_date = Date.strptime(date, '%d-%m-%y')
    rescue ArgumentError
      return { error: "Invalid date format. Please use 'DD-MM-YY'." }
    end

    existing_transactions = transactions.where('created_at <= ?', end_date.end_of_day)

    return {
      credit: credit_sum(end_date),
      debit: debit_sum(end_date),
      balance: balance(end_date),
      transactions_list: existing_transactions
    }
  end

  private

  def credit_sum(date=Date.today)
    transactions.where('created_at <= ?', date.end_of_day).credits.sum(:amount)
  end

  def debit_sum(date=Date.today)
    transactions.where('created_at <= ?', date.end_of_day).debits.sum(:amount)
  end
end
