class RegistrationsController < Devise::RegistrationsController

  def create
    super do
      @account = Account.new
      @account.user_id = resource.id
      @account.balance = 0
      @account.save
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :date_of_birth)
  end
end