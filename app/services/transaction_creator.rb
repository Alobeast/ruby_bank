class TransactionCreator
  def initialize(account)
    @account = account
  end

  def credit(amount)
    begin
      @account.transactions.create!(
        amount: amount,
        transaction_type: :deposit,
        account: @account
        )
    rescue => e
      Rails.logger.error("Failed to credit account: #{e.message}")
    end
  end

  def transfer(amount, counterpart_account)
    errors = []
    ApplicationRecord.transaction do
      @account.transactions.create!(
        amount: amount,
        transaction_type: :transfer_out,
        counterpart_account: counterpart_account
      )

      counterpart_account.transactions.create!(
        amount: amount,
        transaction_type: :transfer_in,
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
end
