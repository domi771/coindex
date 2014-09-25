module Withdraws
  class Bitshare < ::Withdraw
    include ::AasmAbsolutely
    include ::Withdraws::Coinable
    include ::FundSourceable

    def set_fee
      self.fee = "0.02".to_d
    end

  end
end
