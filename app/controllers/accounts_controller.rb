class AccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_account
  before_action :set_balance, only: [:show, :new_transfer]
  before_action :set_transferable_accounts, only: [:new_transfer]

  def show
    @transactions = @account.transactions.all.order(created_at: :desc)
    @balance = @account.balance
  end

  def new_transfer
    if request.post?
      @selected_account_id = params[:counterpart_account_id]
      receiving_account = Account.find_by(id: @selected_account_id)
      @amount = params[:amount].to_d
      if @account.transfer!(@amount, receiving_account)
        redirect_to root_path(@account), notice: "Transfer successful"
      else
        flash.now[:alert] = "Transfer failed. " + @account.errors.full_messages.to_sentence
        render :new_transfer
      end
    end
  end

  private

  def set_account
    @account ||= current_user.account
  end

  def set_balance
    @balance = @account.balance
  end

  def set_transferable_accounts
    @transferable_accounts = Account.where.not(id: @account.id)
  end
end
