module Admin
  module Withdraws
    class SyscoinsController < ::Admin::Withdraws::BaseController
      load_and_authorize_resource :class => '::Withdraws::Syscoin'

      def index
        start_at = DateTime.now.ago(60 * 60 * 24)
        @one_syscoins = @syscoins.with_aasm_state(:accepted).order("id DESC")
        @all_syscoins = @syscoins.without_aasm_state(:accepted).where('created_at > ?', start_at).order("id DESC")
      end

      def show
      end

      def update
        @syscoin.process!
        redirect_to :back, notice: t('.notice')
      end

      def destroy
        @syscoin.reject!
        redirect_to :back, notice: t('.notice')
      end
    end
  end
end
