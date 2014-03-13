class HDWallet < ActiveRecord::Base
  extend Enumerize
  enumerize :currency, in: Currency.codes

  attr_accessor :root_node

  validates_presence_of :currency, :serialized_address
  validate :ensure_root_node_security

  after_find :deserialize_root

  def self.next_address(currency)
    HDWallet.transaction do
      wallet = wallet_for_currency(currency).lock!
      index = wallet.next_index
      address = wallet.address_at(index)

      wallet.next_index += 1
      wallet.save

      PaymentAddress.create(address: address, address_index: index, currency: wallet.currency)
    end
  end

  def address_at i
    root_node.subnode(i).to_address
  end

  private

  def self.wallet_for_currency currency
    where(currency: currency).order('id DESC').first
  end

  def ensure_root_node_security
    return unless serialized_address
    deserialize_root

    error_messages = []
    error_messages << "Private key detected." if(root_node.private_key.present?)
    error_messages << "Private node detected." if(root_node.is_private?)

    if(error_messages.present?)
      error_messages << "For security, only a base58 serialized public node stripped of private key is allowed."
      errors.add :serialized_address, error_messages.join(' ')
    end
  end

  def deserialize_root
    self.root_node = MoneyTree::Node.from_serialized_address(serialized_address)
  end
end

