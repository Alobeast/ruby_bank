class UserCreator
  def initialize(user_params)
    @user_params = user_params
  end

  def create_user_with_account
    ApplicationRecord.transaction do
      user = User.create!(@user_params)
      create_default_account(user)
      user
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error("Error creating user and account: #{e.message}")
      raise ActiveRecord::Rollback
    end
  end

  private

  def create_default_account(user)
    account_number = generate_unique_account_number
    if user.accounts.none?
      user.accounts.create!(account_number: account_number)
    end
  end

  def generate_unique_account_number
    # checking db might become inefficient, development purpose only
    loop do
      account_number = SecureRandom.random_number(1000000000..9999999999).to_s
      return account_number if !Account.exists?(account_number: account_number)
    end
  end
end
