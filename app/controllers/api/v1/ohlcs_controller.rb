module API
  module V1
    class OhlcsController < BaseController
      def show
        if params[:since]
          @ohlc = Global[params[:id]].since_trades(params[:since])
        else
#          @ohlc = Global[params[:id]].trades.reverse
          @ohlcs = Global[params[:date]].ohlcs.reverse
        end
      end
    end
  end
end


