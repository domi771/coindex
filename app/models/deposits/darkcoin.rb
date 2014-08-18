module Deposits
  class Darkcoin < ::Deposit
    include ::AasmAbsolutely
    include ::Deposits::Coinable
  end
end
