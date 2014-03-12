class AddAddressIndexToPaymentAddresses < ActiveRecord::Migration
  def change
    add_column :payment_addresses, :address_index, :integer
  end
end
