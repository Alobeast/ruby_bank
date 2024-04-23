require "test_helper"

class AccountTest < ActiveSupport::TestCase
  def setup
    @account_one = accounts(:one)
    @account_two = accounts(:two)
    @user_one = users(:one)
  end

  test "should record a transaction when account is credited #transaction_creator" do
    account = @account_one
    assert_difference "account.transactions.count", 1, "1 transaction should be created" do
      account.credit!(100)
    end
  end

  test "user's balance should be increased when account is credited #transaction_creator" do
    account = @account_one
    assert_difference "account.balance", 100, "account should be credited" do
      account.credit!(100)
    end
  end

  test "no transaction should be recorded when account is credited with negative amount #transaction_creator" do
    account = @account_one
    assert_no_difference "account.transactions.count", "no transaction should be created" do
      account.credit!(-35)
    end
  end

  test "account cannot be credited with negative amount #transaction_creator" do
    account = @account_one
    assert_no_difference "account.balance", "account balance should not change" do
      account.credit!(-35)
    end
  end

  test "balance should amount to the sum of credit and debit transactions" do
    account = @account_one
    assert account.transactions.any?, "account should have transactions"
    assert_equal 50, account.balance, "balance should equal sum of transactions"
  end

  test "transfer should record 2 transactions #transaction_creator" do
    assert_difference "Transaction.count", 2, "2 transactions should be created" do
      @account_one.transfer!(50, @account_two)
    end
  end

  test "transfer should reduce sender's account balance #transaction_creator" do
    assert_difference "@account_one.balance", -10, "sender's balance should be reduced" do
      @account_one.transfer!(10, @account_two)
    end
  end

  test "transfer should increase recipient's account balance #transaction_creator" do
    assert_difference "@account_two.balance", 10, "recipient's balance should be increased" do
      @account_one.transfer!(10, @account_two)
    end
  end

  test "negative amount transfer can not be performed #transaction_creator" do
    assert_no_difference ["@account_one.balance", "@account_two.balance"], "balances should not change" do
      @account_one.transfer!(-10, @account_two)
    end
  end

  test "transfer with insufficient funds should not go through #transaction_creator" do
    assert_no_difference "@account_one.balance", "sender balance should not change" do
      @account_one.transfer!(1000000, @account_two)
    end
    assert_no_difference "@account_two.balance", "receiver balance should not change" do
      @account_one.transfer!(1000000, @account_two)
    end
  end

  test "user can not transfer to their own account #transaction_creator" do
    assert_no_difference "@account_one.balance", "balances should not change" do
      @account_one.transfer!(10, @account_one)
    end
  end

  test "balance history returns balance and transactions list at given date" do
    account = @account_two
    date = (Date.today - 1.day).strftime('%d-%m-%y')
    balance_history = account.balance_history(date)
    assert_equal 500, balance_history[:credit], "balance history should return total credit at given date"
    assert_equal 150, balance_history[:debit], "balance history should return total debit at given date"
    assert_equal 350, balance_history[:balance], "balance history should return balance at given date"
    assert_equal 2, balance_history[:transactions_list].count, "balance history should return all existing transactions at given date"
  end
end
