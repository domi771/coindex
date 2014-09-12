class MarketController < ApplicationController

  layout 'market'

   def show
      @bid = params[:bid]
      @ask = params[:ask]

      @ask_name = I18n.t("currency.name.#{@ask}")
      @bid_name = I18n.t("currency.name.#{@bid}")

      @market = Market.find(params[:market]) 

      @bids   = Global[@market].bids
      @asks   = Global[@market].asks
      @trades = Global[@market].trades
      @price  = Global[@market].price
      @ticker = Global[@market].ticker

      gon.jbuilder
   end

   #if current_user
   #  redirect_to market_path(current_market) and return
   #end

end

