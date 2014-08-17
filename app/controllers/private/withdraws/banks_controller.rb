module Private::Withdraws
  class BanksController < ::Private::Withdraws::BaseController
    include ::Withdraws::CtrlBankable
    before_action :auth_verified!
    before_action :two_factor_activated!
  end
end
