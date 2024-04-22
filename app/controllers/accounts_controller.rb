class AccountsController < ApplicationController
  before_action :authenticate_user!

  def show
    @account = current_user.account
    @transactions = @account.transactions.all.order(created_at: :desc)
  end
end
