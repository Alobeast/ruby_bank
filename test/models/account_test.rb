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
end
