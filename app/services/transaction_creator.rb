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

  def transfer(amount, counterpart_account)
    errors = []
    ApplicationRecord.transaction do
      record_transaction!(
        amount: amount,
        transaction_type: :transfer_out,
        account: @account,
        counterpart_account: counterpart_account
      )

      record_transaction!(
        amount: amount,
        transaction_type: :transfer_in,
        account: counterpart_account,
        counterpart_account: @account
      )
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error("Transfer failed: #{e.message}")
      errors << e.record.errors.full_messages
      raise ActiveRecord::Rollback
    end
    errors.flatten!
    errors
  end

  private

  def record_transaction!(amount:, transaction_type:, account:, counterpart_account: nil)
    account.transactions.create!(
      amount: amount,
      transaction_type: transaction_type,
      counterpart_account: counterpart_account
    )
  end
end
