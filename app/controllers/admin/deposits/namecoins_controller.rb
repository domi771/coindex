module Admin
  module Deposits
    class NamecoinsController < ::Admin::Deposits::BaseController
      load_and_authorize_resource :class => '::Deposits::Namecoin'

      def index
        start_at = DateTime.now.ago(60 * 60 * 24)
        @namecoins = @namecoins.includes(:member).
          where('created_at > ?', start_at).
          order('id DESC')
      end

      def update
        @namecoin.accept! if @namecoin.may_accept?
        redirect_to :back, notice: t('.notice')
      end
    end
  end
end
