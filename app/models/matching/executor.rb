module Matching
  class TradeExecutionError < StandardError; end

  class Executor

    def initialize(market, ask, bid, price, volume)
      @market = market
      @ask    = OrderAsk.lock(true).find(ask.id)
      @bid    = OrderBid.lock(true).find(bid.id)
      @price  = price
      @volume = volume
    end

    def execute!
      raise TradeExecutionError.new({ask: @ask, bid: @bid, price: @price, volume: @volume}) unless valid?

      ActiveRecord::Base.transaction do
        lock_accounts!

        trade = Trade.create(ask_id: @ask.id, bid_id: @bid_id,
                             price: @price, volume: @volume,
                             currency: @market.id.to_sym, trend: trend)

        @bid.strike trade
        @ask.strike trade

        Global[@market].trigger_trade trade

        trade
      end
    end

    private

    def valid?
      [@ask.volume, @bid.volume].min >= @volume &&
        @ask.price <= @price &&
        @bid.price >= @price
    end

    def involved_accounts
      Account.where(member_id: [@ask.member_id, @bid.member_id]).with_currency(*@market.currency_pair)
    end

    def lock_accounts!
      involved_accounts.lock.to_a
    end

    def trend
      @price >= @market.latest_price ? 'up' : 'down'
    end

  end
end
