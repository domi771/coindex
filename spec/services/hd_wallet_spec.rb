require 'spec_helper'

describe HDKeychain do
  let(:master) { MoneyTree::Master.new }
  let(:serialized) { master.node_for_path("m/0'/0").to_serialized_address }
  let(:keychain) { described_class.new(serialized) }

  describe '#initialize' do
    it 'deserializes' do
      expect(keychain.root_node).to be_a(MoneyTree::Node)
      expect(keychain.root_node.private_key).to be_nil
    end

    context 'when serialization of a public node with private key is passed in' do
      let(:serialized) { master.node_for_path("m/0'/0").to_serialized_address(:private) }

      it 'throws an exception' do
        expect {
          keychain
        }.to raise_error(HDKeychain::RootNodeError,
                         /Private key detected\. For security, only a base58 serialized public node stripped of private key is allowed/)
      end
    end

    context 'when serialization of a private node is passed in' do
      let(:serialized) { master.node_for_path("m/0'/0'").to_serialized_address() }

      it 'throws an exception' do
        expect {
          keychain
        }.to raise_error(HDKeychain::RootNodeError,
                         /Private node detected\. For security, only a base58 serialized public node stripped of private key is allowed/)
      end
    end
  end

  describe '#address_at' do
    it 'generate address at the specified index at 1 level down from the root' do
      address = keychain.address_at(42)

      subnode = keychain.root_node.subnode(42)
      expect(subnode.depth).to eq(keychain.root_node.depth + 1)
      expect(address).to eq(subnode.to_address)
    end
  end
end
