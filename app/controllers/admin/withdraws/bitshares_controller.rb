module Admin
  module Withdraws
    class BitsharesController < ::Admin::Withdraws::BaseController
      load_and_authorize_resource :class => '::Withdraws::Bitshares'

      def index
        start_at = DateTime.now.ago(60 * 60 * 24)
        @one_bitshares = @bitshares.with_aasm_state(:accepted).order("id DESC")
        @all_bitshares = @bitshares.without_aasm_state(:accepted).where('created_at > ?', start_at).order("id DESC")
      end

      def show
      end

      def update
        @bitshares.process!
        redirect_to :back, notice: t('.notice')
      end

      def destroy
        @bitshares.reject!
        redirect_to :back, notice: t('.notice')
      end
    end
  end
end
