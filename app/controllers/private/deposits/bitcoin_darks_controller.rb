module Private
  module Deposits
    class BitcoinDarksController < ::Private::Deposits::BaseController
      include ::Deposits::CtrlCoinable
    end
  end
end
