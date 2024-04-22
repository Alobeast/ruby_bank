class AddCheckConstraintToTransactions < ActiveRecord::Migration[7.0]
  def change
    add_check_constraint :transactions, 'amount > 0', name: 'check_amount_positive'
  end
end
