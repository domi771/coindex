module Admin
  module Statistic
    class TradesController < BaseController

      START_TIME = Time.now.beginning_of_day
      END_TIME  = Time.now
      TODAY_TRADE_RESULT = Trade.search(created_at_gteq: START_TIME, created_at_lteq: END_TIME).result

      def show
        @q = Trade.search(params[:q])

        @count = @q.result.count
        @volume_count = @q.result.sum(:volume)

        @total_price = @q.result.sum("(volume * price)")

        @today_trade_count = today_trade_count
        @today_coin_count  = today_coin_count
        @today_total_price = today_total_price
      end

      private
        def today_trade_count
          TODAY_TRADE_RESULT.count
        end

        def today_coin_count
          TODAY_TRADE_RESULT.sum(:volume)
        end

        def today_total_price
          TODAY_TRADE_RESULT.sum("(volume * price)")
        end
    end
  end
end
