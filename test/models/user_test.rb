require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user_one = users(:one)
  end

  test "user is valid with valid attributes" do
    user = User.new(email: "test@example.com", password: "password123")
    assert user.valid?, "User should be valid: #{user.errors.full_messages.to_sentence}"
  end

  test "user is not valid without an email" do
    user = User.new(password: "password123")
    assert_not user.valid?, "User should not be valid without an email"
  end

  test "user is not valid without a password" do
    user = User.new(email: "test@example.com")
    assert_not user.valid?, "User should not be valid without a password"
  end

  test "user email should be unique" do
    user1 = @user_one
    user2 = User.new(email: user1.email, password: "password123")
    assert_not user2.valid?, "User email should be unique"
    assert_includes user2.errors[:email], "has already been taken"
  end

  test "should create a valid user" do
    user = User.create(email: "newuser@example.com", password: "password123")
    assert user.persisted?, "User should have been saved successfully"
  end

  test "using the user creator service creates a user and their account" do
    user = User.create_user_with_account("newuser@example.com","password123")
    assert user.persisted?, "User should have been saved successfully"
    assert user.account, "User should have an associated account"
  end

  test "the user creation service should fail with invalid user params" do
    assert_no_difference "User.count", "should not create user nor account" do
      User.create_user_with_account("", "password123")
    end
  end
end
