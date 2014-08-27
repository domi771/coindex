module Deposits
  class LottoShare < ::Deposit
    include ::AasmAbsolutely
    include ::Deposits::Coinable
  end
end
