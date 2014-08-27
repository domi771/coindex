module Admin
  module Deposits
    class LottoSharesController < ::Admin::Deposits::BaseController
      load_and_authorize_resource :class => '::Deposits::LottoShares'

      def index
        start_at = DateTime.now.ago(60 * 60 * 24)
        @lotto_shares = @lotto_shares.includes(:member).
          where('created_at > ?', start_at).
          order('id DESC')
      end

      def update
        @lotto_shares.accept! if @lotto_shares.may_accept?
        redirect_to :back, notice: t('.notice')
      end
    end
  end
end
