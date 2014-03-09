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
end
