require "test_helper"

class AccountTest < ActiveSupport::TestCase
  def setup
    @account_one = accounts(:one)
    @account_two = accounts(:two)
    @user_one = users(:one)
  end

  test "should record a transaction when account is credited" do
    assert_difference "@account_one.transactions.count", 1, "1 transaction should be created" do
      @account_one.credit!(100)
    end
  end
end
