require 'spec_helper'

describe Currency do
  describe '.codes' do
    it 'returns all available currencies' do
      expect(Currency.codes).to eq({:cny=>1, :btc=>2})
    end
  end

  describe '.coin_urls' do
    it 'returns all available currency mapped to their respective rpc url' do
      expect(Currency.coin_urls[:btc]).to be_a(String)
    end
  end

  describe '.coin_wallets' do
    it 'returns all available currency mapped to their respective deserialized wallet' do
      wallet = Currency.coin_wallets[:btc]
      expect(wallet).to be_a(HDWallet)
      expect(wallet.currency).to eq(Currency.currencies.btc)
      expect(wallet.keychain).to be_a(HDKeychain)
    end
  end
end
