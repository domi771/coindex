class AddColumnBsbToWithdraws < ActiveRecord::Migration
  def change
    add_column :withdraws, :bsb, :string
  end
end
