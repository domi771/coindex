module Private
  module Deposits
    class BitsharesController < ::Private::Deposits::BaseController
      include ::Deposits::CtrlCoinable
    end
  end
end
