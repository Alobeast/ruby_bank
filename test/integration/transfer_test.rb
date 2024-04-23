require 'test_helper'

class TransferTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user_one = users(:one)
    @user_two = users(:two)
    sign_in @user_one
  end

  test "user can send a transfer" do
    user_one = @user_one
    user_two = @user_two
    get new_transfer_account_path

    user_one_balance_before = user_one.account.balance

    assert_difference "user_two.account.balance", 10.00,
    "user two account should be credited"   do
      post new_transfer_account_path, params: {
        counterpart_account_id: user_two.account.id,
        amount: 10.00
      }
    end

    assert_redirected_to root_path
    follow_redirect!
    assert_equal user_one_balance_before - 10.00, user_one.account.balance, "user one account should be debited"
  end

  test "transfer fails if amount is negative" do
    user_one = @user_one
    get new_transfer_account_path

    assert_no_difference "user_one.account.balance" do
      post new_transfer_account_path, params: {
          counterpart_account_id: @user_two.account.id,
          amount: -10.00
        }
    end

      assert_response :success, "Transfer should not be allowed with negative amount"
      assert_includes response.body, "Transfer Funds - Available"
      assert_includes response.body, "Amount to Transfer"
  end

  test "transfer fails if insufficient funds" do
    user_one = @user_one
    get new_transfer_account_path

    assert_no_difference "user_one.account.balance" do
      post new_transfer_account_path, params: {
          counterpart_account_id: @user_two.account.id,
          amount: 5000000.00
        }
    end

    assert_response :success, "Transfer should not be allowed with insufficient funds"
    assert_includes response.body, "Transfer Funds - Available"
    assert_includes response.body, "Amount to Transfer"
  end
end
