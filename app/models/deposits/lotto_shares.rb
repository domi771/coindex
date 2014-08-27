module Deposits
  class LottoShares < ::Deposit
    include ::AasmAbsolutely
    include ::Deposits::Coinable
  end
end
