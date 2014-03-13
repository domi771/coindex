class CreateHdWallets < ActiveRecord::Migration
  def change
    create_table :hd_wallets do |t|
      t.string :serialized_address
      t.integer :next_index, default: 0
      t.integer :currency

      t.timestamps
    end
  end
end
