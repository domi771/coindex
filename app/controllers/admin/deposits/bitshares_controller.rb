module Admin
  module Deposits
    class BitsharesController < ::Admin::Deposits::BaseController
      load_and_authorize_resource :class => '::Deposits::Bitshares'

      def index
        start_at = DateTime.now.ago(60 * 60 * 24)
        @bitshares = @bitshares.includes(:member).
          where('created_at > ?', start_at).
          order('id DESC')
      end

      def update
        @bitshares.accept! if @bitshares.may_accept?
        redirect_to :back, notice: t('.notice')
      end
    end
  end
end
