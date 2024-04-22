class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.references :account, null: false, foreign_key: true
      t.decimal :amount, precision: 12, scale: 2, null: false
      t.integer :transaction_type, null: false
      t.integer :counterpart_account_id, null: true, foreign_key: { to_table: :accounts }

      t.timestamps
    end
  end
end
