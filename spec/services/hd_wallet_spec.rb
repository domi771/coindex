require 'spec_helper'

describe HDWallet do
  let(:serialized) { "xpub6AhiyLjMpHPdCo2UXZPtjhjyQkh4JDYBYGParSbcg2okbzV7R6bTsBei3Z9kPHpQ1n6cXB1FmakgfXzvoCUpN1sWrwYjAa7oC1Yd5kdjnev" }
  let(:wallet) { described_class.new(serialized) }

  describe '#initialize' do
    it 'deserializes' do
      expect(wallet.root_node).to be_a(MoneyTree::Node)
      expect(wallet.root_node.private_key).to be_nil
    end

    context 'when serialization of a private node is passed in' do
      let(:serialized) { "xprv9wJeRbmV4Uwoo4b7kmstLgtWsCSRhGFpZRWKmvk6FLWcgAvRtkALPVGEjPy7BdU2nbtG8GaJhqui4jyDJ25qrscEgqDPCxorQqjyFuaxCRn" }

      it 'throws an exception' do
        expect {
          wallet
        }.to raise_error(StandardError, "Private node detected. Only base58 serialized public node is allowed for security reasons.")
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
end
