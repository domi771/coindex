module Deposits
  class Peercoin < ::Deposit
    include ::AasmAbsolutely
    include ::Deposits::Coinable
  end
end
