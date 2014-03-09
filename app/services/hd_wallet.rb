class HDWallet
  attr_reader :root_node

  def initialize(public_base58)
    root_node = MoneyTree::Node.from_serialized_address(public_base58)
    if(root_node.private_key.present?)
      raise 'Private node detected. Only base58 serialized public node is allowed for security reasons.'
    end
    @root_node = root_node
  end

end
