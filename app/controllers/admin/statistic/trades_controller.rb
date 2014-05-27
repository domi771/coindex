module Admin
  module Statistic
    class TradesController < BaseController
      def show
        currency = params[:q] ? params[:q][:currency_eq].to_i : Market.first.code
        @coin_name = Market.find_by_code(currency).id

        @created_at_gteq = if params[:q] && params[:q].has_key?(:created_at_gteq)
          params[:q][:created_at_gteq]
        else
          Date.today
        end

        @created_at_lteq = if params[:q] && params[:q].has_key?(:created_at_lteq)
          @created_at_lteq = params[:q][:created_at_lteq]
        else
          Time.now
        end

        @q = Trade.search(params[:q])

        @count = @q.result.count
        @volume_count = @q.result.sum(:volume)
        @total_price  = @q.result.sum("(volume * price)")
        @trade_members_count = (@q.result.pluck("DISTINCT(ask_member_id)") | @q.result.pluck("DISTINCT(bid_member_id)")).count

        gon.stat_count = @q.result.group("date(created_at)").count
        gon.stat_volume_count = @q.result.group("date(created_at)").sum(:volume)
        gon.stat_trade_members_count = @q.result.group("date(created_at)").sum("(volume * price)")

        @today_trade_count = today_trade_count(currency)
        @today_coin_count  = today_coin_count(currency)
        @today_total_price = today_total_price(currency)
        @today_trade_members_count = today_trade_members_count(currency)
      end

      private

        def init_query(currency)
          start_time = Date.today
          end_time   = Time.now

          Trade.search(created_at_gteq: start_time, created_at_lteq: end_time, currency_eq: currency).result
        end

        def today_trade_count(currency)
          init_query(currency).count
        end

        def today_coin_count(currency)
          init_query(currency).sum(:volume)
        end

        def today_total_price(currency)
          init_query(currency).sum("(volume * price)")
        end

        def today_trade_members_count(currency)
          ask_members = init_query(currency).pluck("DISTINCT(ask_member_id)")
          bid_members = init_query(currency).pluck("DISTINCT(bid_member_id)")

          (ask_members | bid_members).count
        end
    end
  end
end
