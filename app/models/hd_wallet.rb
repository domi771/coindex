class HDWallet < ActiveRecord::Base
  attr_accessor :keychain

  def self.wallet_where(options)
    where(options).order('id DESC').first_or_create
  end
end

