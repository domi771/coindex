class MarketController < ApplicationController

  layout 'market'

   def show

      @market = Market.find(params[:market])

      s = params[:market]
      @bid = s[3,3]

      s = params[:market]
      @ask = s[0,3]

      @ask_name = I18n.t("currency.name.#{@ask}")
      @bid_name = I18n.t("currency.name.#{@bid}")

      @ask_code = I18n.t("currency.code.#{@ask}")
      @bid_code = I18n.t("currency.code.#{@bid}")


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

