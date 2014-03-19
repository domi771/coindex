module Private
  class PaymentAddressesController < BaseController
    def create
      account = current_user.get_account(params[:currency])
      payment_address = account.next_payment_address
      redirect_to coin_deposits_path(currency: :btc)
    end
  end
end

