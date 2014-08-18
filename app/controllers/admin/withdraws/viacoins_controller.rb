module Admin
  module Withdraws
    class ViacoinsController < ::Admin::Withdraws::BaseController
      load_and_authorize_resource :class => '::Withdraws::Viacoin'

      def index
        start_at = DateTime.now.ago(60 * 60 * 24)
        @one_viacoins = @viacoins.with_aasm_state(:accepted).order("id DESC")
        @all_viacoins = @viacoins.without_aasm_state(:accepted).where('created_at > ?', start_at).order("id DESC")
      end

      def show
      end

      def update
        @viacoin.process!
        redirect_to :back, notice: t('.notice')
      end

      def destroy
        @viacoin.reject!
        redirect_to :back, notice: t('.notice')
      end
    end
  end
end
