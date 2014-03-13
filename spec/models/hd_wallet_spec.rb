require 'spec_helper'

describe HDWallet do
  before do
    valid_serialized_address = MoneyTree::Master.new.node_for_path("m/0'/0").to_serialized_address
    described_class.create(serialized_address: valid_serialized_address, currency: Currency.codes[:btc])
  end

  let(:wallet) { described_class.last }

  describe 'after find' do
    it 'assigns the deserialized object to wallet.root' do
      expect(wallet.root_node).to be_a(MoneyTree::Node)
      expect(wallet.root_node.private_key).to be_nil
    end
  end

  describe 'validations' do
    it { should validate_presence_of(:currency) }
    it { should ensure_inclusion_of(:currency).in_array(Currency.codes.values) }

    it { should validate_presence_of(:serialized_address) }

    describe 'root node security' do
      let(:master) { MoneyTree::Master.new }
      let(:wallet) { described_class.new serialized: serialized }

      context 'when serialization of a public node with private key is passed in' do
        let(:serialized) { master.node_for_path("m/0'/0").to_serialized_address(:private) }

        it 'results in an error' do
          should_not allow_value(serialized).
            for(:serialized_address).
              with_message(/Private key detected\. For security, only a base58 serialized public node stripped of private key is allowed/)
        end
      end

      context 'when serialization of a private node is passed in' do
        let(:serialized) { master.node_for_path("m/0'/0'").to_serialized_address() }

        it 'results in an error' do
          should_not allow_value(serialized).
            for(:serialized_address).
              with_message(/Private node detected\. For security, only a base58 serialized public node stripped of private key is allowed/)
        end
      end
    end
  end

  describe '#address_at' do
    it 'generate address at the specified index at 1 level down from the root' do
      address = wallet.address_at(42)

      subnode = wallet.root_node.subnode(42)
      expect(subnode.depth).to eq(wallet.root_node.depth + 1)
      expect(address).to eq(subnode.to_address)
    end
  end

  describe '.next_address' do
    let(:currency) { Currency.codes[:btc] }

    it 'increment the next_index for the wallet' do
      expect {
        described_class.next_address(currency)
      }.to change{ HDWallet.where(currency: currency).last.next_index }.by(1)
    end

    it 'stores the address with index and currency' do
      payment_address = nil
      expect {
        payment_address = described_class.next_address(currency)
      }.to change(PaymentAddress, :count).by(1)

      expect(payment_address.currency_value).to eq(currency)

      next_payment_address = described_class.next_address(currency)
      expect(next_payment_address.address_index).to eq(payment_address.address_index + 1)
    end

    context 'when there exists multiple wallets for the same currency' do
      def create_wallet
        HDWallet.create serialized_address: MoneyTree::Master.new.to_serialized_address, currency: currency
      end

      let(:wallet) { create_wallet }

      before do
        create_wallet
        wallet
      end

      it 'uses the last created one' do
        expect {
          described_class.next_address(currency)
        }.to change{ wallet.reload.next_index }.by(1)
      end
    end
  end
end
