class User < ApplicationRecord
  devise :database_authenticatable, :rememberable, :validatable

  has_many :accounts, dependent: :destroy

  def self.create_user_with_account(email, password)
    user_params = {email: email, password: password}
    user_creator = UserCreator.new(user_params)
    user_creator.create_user_with_account
  end

  def account
    # for now we consider that user can only have one account
    accounts.first
  end
end
