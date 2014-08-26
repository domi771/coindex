module Deposits
  class BitcoinDark < ::Deposit
    include ::AasmAbsolutely
    include ::Deposits::Coinable
  end
end
