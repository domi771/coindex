module Private
  class WithdrawsController < BaseController
    before_action :auth_activated!

    def index
      @channels = WithdrawChannel.all
    end

  end
end
