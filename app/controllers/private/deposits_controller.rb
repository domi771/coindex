module Private
  class DepositsController < BaseController
    before_action :auth_activated!

    def index
      @deposits = DepositChannel.all.sort
    end

  end
end
