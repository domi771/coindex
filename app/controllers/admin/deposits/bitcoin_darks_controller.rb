module Admin
  module Deposits
    class BitcoinDarksController < ::Admin::Deposits::BaseController
      load_and_authorize_resource :class => '::Deposits::BitcoinDark'

      def index
        start_at = DateTime.now.ago(60 * 60 * 24)
        @bitcoin_darks = @bitcoin_darks.includes(:member).
          where('created_at > ?', start_at).
          order('id DESC')
      end

      def update
        @bitcoin_dark.accept! if @bitcoin_dark.may_accept?
        redirect_to :back, notice: t('.notice')
      end
    end
  end
end
