class User < ApplicationRecord
  devise :database_authenticatable, :rememberable, :validatable

  has_many :accounts, dependent: :destroy

  def account
    # for now we consider that user can only have one account
    accounts.first
  end
end
