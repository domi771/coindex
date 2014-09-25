module Private::Withdraws
    class BitsharesController < ::Private::Withdraws::BaseController
      include ::Withdraws::CtrlCoinable
      before_action :two_factor_activated!
  end
end

