class AccountsController < ApplicationController
  before_action :set_account, only: [:edit, :update]

  def show
  end

  def edit
  end

 def update
   recharge = params.require(:account).permit(:recharge_amount)['recharge_amount']
   @account.balance += recharge.to_f
   if @account.save
     flash[:komunikat] = 'Your account was recharged.'
     redirect_to '/accounts/edit'
   end
 end

  private
  def set_account
    @account = current_user.account
  end

end
