module Admin
  module Withdraws
    class LottoSharesController < ::Admin::Withdraws::BaseController
      load_and_authorize_resource :class => '::Withdraws::LottoShares'

      def index
        start_at = DateTime.now.ago(60 * 60 * 24)
        @one_lotto_shares = @lotto_shares.with_aasm_state(:accepted).order("id DESC")
        @all_lotto_shares = @lotto_shares.without_aasm_state(:accepted).where('created_at > ?', start_at).order("id DESC")
      end

      def show
      end

      def update
        @lotto_shares.process!
        redirect_to :back, notice: t('.notice')
      end

      def destroy
        @lotto_shares.reject!
        redirect_to :back, notice: t('.notice')
      end
    end
  end
end
