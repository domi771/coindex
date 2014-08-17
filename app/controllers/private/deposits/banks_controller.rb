module Private
  module Deposits
    class BanksController < ::Private::Deposits::BaseController
      include ::Deposits::CtrlBankable
      before_action :auth_verified!
    end
  end
end
