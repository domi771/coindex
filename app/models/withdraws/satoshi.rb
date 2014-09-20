module Withdraws
  class Satoshi < ::Withdraw
    include ::AasmAbsolutely
    include ::Withdraws::Coinable
    include ::FundSourceable

    def set_fee
      self.fee = "0.0002".to_d
    end

  end
end
