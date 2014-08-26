module Admin
  class Ability
    include CanCan::Ability

    def initialize(user)
      return unless user.admin?

      can :read, Order
      can :read, Trade
      can :read, Member
      can :read, Proof
      can :update, Member
      can :toggle, Member
      can :update, Proof
      can :manage, Document
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

      can :stat, ::Member
    end
  end
end
