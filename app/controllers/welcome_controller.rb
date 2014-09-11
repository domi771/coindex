class WelcomeController < ApplicationController
  layout 'landing'

  def show
      gon.jbuilder controller: self
  end

  def index
      gon.jbuilder controller: self
	
    if current_user
      redirect_to market_path(current_market) and return
    end
  end
end
