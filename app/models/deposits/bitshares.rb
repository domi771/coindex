module Deposits
  class Bitshares < ::Deposit
    include ::AasmAbsolutely
    include ::Deposits::Coinable
  end
end
