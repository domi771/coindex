module Admin
  module Statistic
    class TradesController < BaseController
      def show
        @q = Trade.search(params[:q])

        @count = @q.result.count
        @volume_count = @q.result.sum(:volume)
        @total_price = @q.result.sum("(volume * price)")
        @trade_members_count = (@q.result.pluck("DISTINCT(ask_member_id)") | @q.result.pluck("DISTINCT(bid_member_id)")).count

        gon.stat_count = @q.result.group("date(created_at)").count
        gon.stat_volume_count = @q.result.group("date(created_at)").sum(:volume)
        gon.stat_trade_members_count = @q.result.group("date(created_at)").sum("(volume * price)")

        @today_trade_count = today_trade_count
        @today_coin_count  = today_coin_count
        @today_total_price = today_total_price
        @today_trade_members_count = today_trade_members_count
      end

      private

        def init_query
          start_time = Time.now.beginning_of_day
          end_time   = Time.now

          Trade.search(created_at_gteq: start_time, created_at_lteq: end_time).result
        end

        def today_trade_count
          init_query.count
        end

        def today_coin_count
          init_query.sum(:volume)
        end

        def today_total_price
          init_query.sum("(volume * price)")
        end

        def today_trade_members_count
          ask_members = init_query.pluck("DISTINCT(ask_member_id)")
          bid_members = init_query.pluck("DISTINCT(bid_member_id)")

          (ask_members | bid_members).count
        end
    end
  end
end
