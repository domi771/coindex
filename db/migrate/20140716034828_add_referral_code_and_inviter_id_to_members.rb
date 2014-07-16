class AddReferralCodeAndInviterIdToMembers < ActiveRecord::Migration
  def change
    add_column :members, :referral_code, :string, limit: 32
    add_column :members, :inviter_id, :integer

    add_index :members, :inviter_id
  end
end
