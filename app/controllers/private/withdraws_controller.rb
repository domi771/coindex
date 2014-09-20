module Private
  class WithdrawsController < BaseController
    before_action :auth_activated!
    before_action :two_factor_activated!

    def index
      @channels = WithdrawChannel.all
    end

  end
end
