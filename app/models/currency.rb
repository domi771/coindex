class Currency < Settingslogic
  def self.makeup(one, two)
    codes = self.codes
    codes[one.to_sym] ^ codes[two.to_sym]
  end

  def self.coin_urls
    @coins ||= extract_coin_property :rpc
  end

  def self.coin_wallets
    @wallets ||= extract_coin_property(:hdwallet) do |currency, hex|
      wallet = HDWallet.wallet_where(serialized_address: hex, currency: currencies[currency])
      wallet.keychain = HDKeychain.new hex
      wallet
    end
  end

  def self.codes
    # {:currency => :currency_code, ...}
    @codes ||= self.currencies.symbolize_keys
  end

  source "#{Rails.root}/config/currency.yml"
  namespace Rails.env
  suppress_errors Rails.env.production?

  private

  def extract_coin_property(property)
    HashWithIndifferentAccess[
      self.coins.map do |k, v|
        value = v[property.to_s]
        value = yield(k, value) if block_given?
        [k, value]
      end
    ]
  end
end
