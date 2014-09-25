module Deposits
  class Bitshare < ::Deposit
    include ::AasmAbsolutely
    include ::Deposits::Coinable
  end
end
