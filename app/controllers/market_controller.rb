class MarketController < ApplicationController
  layout 'landing'

   def market
      @market = Global[params[:id]].market
   end

   def show
      @bid = params[:bid]
      @ask = params[:ask]

      @ask_name = I18n.t("currency.name.#{@ask}")
      @bid_name = I18n.t("currency.name.#{@bid}")

      #@market = Market.find(params[:market])
      @market = Global[params[:id]].market

      @bids   = Global[@market].bids
      @asks   = Global[@market].asks
      @trades = Global[@market].trades
      @price  = Global[@market].price
      @ticker = Global[@market].ticker

      @order_bid = OrderBid.empty
      @order_ask = OrderAsk.empty

      gon.jbuilder
    end

    def set_default_market
      #cookies[:market_id] = @market.id
      cookies[:market_id] = Global[params[:id]].market  
    end

end

