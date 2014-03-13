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

  describe '.find_or_create_wallets_from_config' do
    it 'does nothing if the wallet is found in database' do
      wallet = HDWallet.create(serialized_address: Currency.coins.btc.hdwallet, currency: Currency.codes[:btc])

      expect {
        described_class.find_or_create_wallets_from_config
      }.to_not change(HDWallet, :count)
    end

    it 'creates a wallet if the configured wallet is not found in database' do
      expect {
        described_class.find_or_create_wallets_from_config
      }.to change(HDWallet, :count).by(1)

      expect(HDWallet.last.serialized_address).to eq Currency.coins.btc.hdwallet
      expect(HDWallet.last.currency_value).to eq Currency.codes[:btc]
    end
  end
end
