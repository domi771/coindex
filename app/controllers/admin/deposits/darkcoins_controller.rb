module Admin
  module Deposits
    class DarkcoinsController < ::Admin::Deposits::BaseController
      load_and_authorize_resource :class => '::Deposits::Darkcoin'

      def index
        start_at = DateTime.now.ago(60 * 60 * 24)
        @darkcoins = @darkcoins.includes(:member).
          where('created_at > ?', start_at).
          order('id DESC')
      end

      def update
        @darkcoin.accept! if @darkcoin.may_accept?
        redirect_to :back, notice: t('.notice')
      end
    end
  end
end
