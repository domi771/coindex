class WelcomeController < ApplicationController
  layout 'landing'

  def market
      @markets = [].page(params[:page]).per(20)
      gon.jbuilder
      #gon.jbuilder controller: self

  end

  def show
      #@markets  = Global[@markets].market
      @markets = [].page(params[:page]).per(20)
      gon.jbuilder

  end

  def index

    if current_user
      redirect_to market_path(current_market) and return
    end
  end
end
