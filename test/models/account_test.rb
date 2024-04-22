require "test_helper"

class AccountTest < ActiveSupport::TestCase
  def setup
    @account_one = accounts(:one)
    @account_two = accounts(:two)
    @user_one = users(:one)
  end

  test "should record a transaction when account is credited" do
    account = @account_one
    assert_difference "account.transactions.count", 1, "1 transaction should be created" do
      account.credit!(100)
    end
  end

  test "user's balance should be increased when account is credited" do
    account = @account_one
    assert_difference "account.balance", 100, "account should be credited" do
      account.credit!(100)
    end
  end

  test "no transaction should be recorded when account is credited with negative amount" do
    account = @account_one
    assert_no_difference "account.transactions.count", "no transaction should be created" do
      account.credit!(-35)
    end
  end
  test "account cannot be credited with negative amount" do
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

  test "transfer should record 2 transactions" do
    assert_difference "Transaction.count", 2, "2 transactions should be created" do
      @account_one.transfer!(50, @account_two)
    end
  end

  test "transfer should reduce sender's account balance" do
    assert_difference "@account_one.balance", -10, "sender's balance should be reduced" do
      @account_one.transfer!(10, @account_two)
    end
  end

  test "transfer should increase recipient's account balance" do
    assert_difference "@account_two.balance", 10, "recipient's balance should be increased" do
      @account_one.transfer!(10, @account_two)
    end
  end

  test "negative amount transfer can not be performed" do
    assert_no_difference ["@account_one.balance", "@account_two.balance"], "balances should not change" do
      @account_one.transfer!(-10, @account_two)
    end
  end

  test "transfer with insufficient funds should not go through" do
    assert_no_difference "@account_one.balance", "sender balance should not change" do
      @account_one.transfer!(1000000, @account_two)
    end
    assert_no_difference "@account_two.balance", "receiver balance should not change" do
      @account_one.transfer!(1000000, @account_two)
    end
  end

  test "user can not transfer to their own account" do
    assert_no_difference "@account_one.balance", "balances should not change" do
      @account_one.transfer!(10, @account_one)
    end
  end
end
