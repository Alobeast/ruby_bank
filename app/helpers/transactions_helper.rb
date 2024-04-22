module TransactionsHelper
  def transaction_color_class(transaction)
    if transaction.deposit? || transaction.transfer_in?
      "text-green-500"
    elsif transaction.withdrawal? || transaction.transfer_out?
      "text-red-500"
    end
  end
end
