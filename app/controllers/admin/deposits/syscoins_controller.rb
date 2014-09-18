module Admin
  module Deposits
    class SyscoinsController < ::Admin::Deposits::BaseController
      load_and_authorize_resource :class => '::Deposits::Syscoin'

      def index
        start_at = DateTime.now.ago(60 * 60 * 24)
        @syscoins = @syscoins.includes(:member).
          where('created_at > ?', start_at).
          order('id DESC')
      end

      def update
        @syscoin.accept! if @syscoin.may_accept?
        redirect_to :back, notice: t('.notice')
      end
    end
  end
end
