module Deposits
  class Syscoin < ::Deposit
    include ::AasmAbsolutely
    include ::Deposits::Coinable
  end
end
