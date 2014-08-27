module Private
  module Deposits
    class LottoSharesController < ::Private::Deposits::BaseController
      include ::Deposits::CtrlCoinable
    end
  end
end
