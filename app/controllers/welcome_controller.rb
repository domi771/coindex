class WelcomeController < ApplicationController
  layout 'landing'

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

      @order_bid = OrderBid.empty
      @order_ask = OrderAsk.empty

      @member = current_user

      @member.orders.with_currency(@market).tap do |query|
        @orders_wait = query.with_state(:wait)
        @orders_cancel = query.with_state(:cancel).last(5)
      end

      @trades_done = Trade.for_member(params[:market], current_user, limit: 100)

      gon.jbuilder
    end

  def index


      @market = 'ltcbtc'

      @bids   = Global[@market].bids
      @asks   = Global[@market].asks
      @trades = Global[@market].trades
      @price  = Global[@market].price
      @ticker = Global[@market].ticker

      gon.jbuilder

    if current_user
      redirect_to market_path(current_market) and return
    end
  end
end
