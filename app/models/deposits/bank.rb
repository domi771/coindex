# == Schema Information
#
# Table name: deposits
#
#  id         :integer          not null, primary key
#  account_id :integer
#  member_id  :integer
#  currency   :integer
#  amount     :decimal(32, 16)
#  fee        :decimal(32, 16)
#  fund_uid   :string(255)
#  fund_extra :string(255)
#  txid       :string(255)
#  state      :integer
#  aasm_state :string(255)
#  created_at :datetime
#  updated_at :datetime
#  done_at    :datetime
#  memo       :string(255)
#  type       :string(255)
#

module Deposits
  class Bank < ::Deposit
    include ::AasmAbsolutely
    include ::Deposits::Bankable
    AWARD_AMOUNT = 5

    def charge!(txid)
      ActiveRecord::Base.transaction do
        self.lock!
        self.submit!
        self.accept!
        self.touch(:done_at)
        self.update_attribute(:txid, txid)
      end

    end

    def self.create_award(invitee, inviter)
      currency_id = Currency.find_by_key("renminbi").id

      invitee_deposit = self.create(account_id: invitee.accounts.where(currency: currency_id).first.id,
                                    member_id: invitee.id, amount: AWARD_AMOUNT, fee: 0, currency: currency_id,
                                    fund_uid: '911911911911', fund_extra: 'cbc') #TODO  Daniel, please use the real value for some attributes latter.

      inviter_deposit = self.create(account_id: inviter.accounts.where(currency: currency_id).first.id,
                                    member_id: inviter.id, amount: AWARD_AMOUNT, fee: 0, currency: currency_id,
                                    fund_uid: '911911911911', fund_extra: 'cbc') #TODO  Daniel, please use the real value for some attributes latter.

      invitee_deposit.charge!("911911911911") #TODO Daniel please fix me latter
      inviter_deposit.charge!("911911911911") #TODO Daniel please fix me latter
    end


  end
end
