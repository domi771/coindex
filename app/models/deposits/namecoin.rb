module Deposits
  class Namecoin < ::Deposit
    include ::AasmAbsolutely
    include ::Deposits::Coinable
  end
end
