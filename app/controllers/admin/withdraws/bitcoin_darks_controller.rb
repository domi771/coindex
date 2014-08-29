module Admin
  module Withdraws
    class BitcoinDarksController < ::Admin::Withdraws::BaseController
      load_and_authorize_resource :class => '::Withdraws::BitcoinDark'

      def index
        start_at = DateTime.now.ago(60 * 60 * 24)
        @one_bitcoin_darks = @bitcoin_darks.with_aasm_state(:accepted).order("id DESC")
        @all_bitcoin_darks = @bitcoin_darks.without_aasm_state(:accepted).where('created_at > ?', start_at).order("id DESC")
      end

      def show
      end

      def update
        @bitcoin_dark.process!
        redirect_to :back, notice: t('.notice')
      end

      def destroy
        @bitcoin_dark.reject!
        redirect_to :back, notice: t('.notice')
      end
    end
  end
end
