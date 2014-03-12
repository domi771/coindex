class HDWallet
  class RootNodeError < StandardError
    def initialize message
      super message << " For security, only a base58 serialized public node stripped of private key is allowed."
    end
  end
  attr_reader :root_node

  def initialize(public_base58)
    root_node = MoneyTree::Node.from_serialized_address(public_base58)

    error_messages = []
    error_messages << "Private key detected." if(root_node.private_key.present?)
    error_messages << "Private node detected." if(root_node.is_private?)

    if(error_messages.present?)
      raise RootNodeError.new(error_messages.join(' '))
    end
    @root_node = root_node
  end

  def address_at i
    root_node.subnode(i).to_address
  end
end

