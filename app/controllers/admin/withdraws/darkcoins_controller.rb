module Admin
  module Withdraws
    class DarkcoinsController < ::Admin::Withdraws::BaseController
      load_and_authorize_resource :class => '::Withdraws::Darkcoin'

      def index
        start_at = DateTime.now.ago(60 * 60 * 24)
        @one_darkcoins = @darkcoins.with_aasm_state(:accepted).order("id DESC")
        @all_darkcoins = @darkcoins.without_aasm_state(:accepted).where('created_at > ?', start_at).order("id DESC")
      end

      def show
      end

      def update
        @darkcoin.process!
        redirect_to :back, notice: t('.notice')
      end

      def destroy
        @darkcoin.reject!
        redirect_to :back, notice: t('.notice')
      end
    end
  end
end
