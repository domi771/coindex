module Deposits
  class Viacoin < ::Deposit
    include ::AasmAbsolutely
    include ::Deposits::Coinable
  end
end
