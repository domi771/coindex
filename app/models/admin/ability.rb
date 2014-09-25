module Admin
  class Ability
    include CanCan::Ability

    def initialize(user)
      return unless user.admin?

      can :read, Order
      can :read, Trade
      can :read, Proof
      can :update, Proof
      can :manage, Document
      can :manage, Member
      can :manage, Ticket
      can :manage, IdDocument
      can :manage, TwoFactor

      can :menu, Deposit
      can :manage, ::Deposits::Bank
      can :manage, ::Deposits::Satoshi
      can :manage, ::Deposits::Litecoin
      can :manage, ::Deposits::Viacoin
      can :manage, ::Deposits::Darkcoin
      can :manage, ::Deposits::BitcoinDark
      can :manage, ::Deposits::Namecoin
      can :manage, ::Deposits::Dogecoin
      can :manage, ::Deposits::Peercoin
      can :manage, ::Deposits::Urocoin
      can :manage, ::Deposits::LottoShare
      can :manage, ::Deposits::Syscoin
      can :manage, ::Deposits::Bitshare

      can :menu, Withdraw
      can :manage, ::Withdraws::Bank
      can :manage, ::Withdraws::Satoshi
      can :manage, ::Withdraws::Litecoin
      can :manage, ::Withdraws::Viacoin
      can :manage, ::Withdraws::Darkcoin
      can :manage, ::Withdraws::Namecoin
      can :manage, ::Withdraws::Peercoin
      can :manage, ::Withdraws::BitcoinDark
      can :manage, ::Withdraws::Dogecoin
      can :manage, ::Withdraws::Urocoin
      can :manage, ::Withdraws::LottoShare
      can :manage, ::Withdraws::Syscoin
      can :manage, ::Withdraws::Bitshare

      can :stat, ::Member

    end
  end
end
