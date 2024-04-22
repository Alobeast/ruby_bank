class TransactionCreator
  def initialize(account)
    @account = account
  end

  def credit(amount)
    errors = []
    ApplicationRecord.transaction do
      record_transaction!(
        amount: amount,
        transaction_type: :deposit,
        account: @account
        )
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error("Failed to credit account: #{e.message}")
      errors << e.record.errors.full_messages
      raise ActiveRecord::Rollback
    end
    errors.flatten!
    errors
  end

  private

  def record_transaction!(amount:, transaction_type:, account:)
    account.transactions.create!(
      amount: amount,
      transaction_type: transaction_type
    )
  end
end
