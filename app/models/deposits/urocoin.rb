module Deposits
  class Urocoin < ::Deposit
    include ::AasmAbsolutely
    include ::Deposits::Coinable
  end
end
