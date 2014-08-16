module Private
  class AssetsController < BaseController
    layout 'application', only: [:index]

    before_action :auth_activated!

    def index
      @chf_assets  = Currency.assets('chf')
      @btc_proof   = Proof.current :btc
      @chf_proof   = Proof.current :chf
      @btc_account = current_user.accounts.with_currency(:btc).first
      @chf_account = current_user.accounts.with_currency(:chf).first
    end

    def partial_tree
      account    = current_user.accounts.with_currency(params[:id]).first
      @timestamp = Proof.with_currency(params[:id]).last.timestamp
      @json      = account.partial_tree.to_json.html_safe
      respond_to do |format|
        format.js
      end
    end

  end
end
