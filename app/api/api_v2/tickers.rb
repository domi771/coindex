module APIv2
  class Tickers < Grape::API
    helpers ::APIv2::NamedParams

    desc 'Get ticker of specific market.'
    params do
      use :market
    end
    get "/tickers/:market" do
      ticker = Global[params[:market]].ticker

      { at: ticker[:at],
        ticker: {
          buy: ticker[:buy],
          sell: ticker[:sell],
          low: ticker[:low],
          high: ticker[:high],
          last: ticker[:last],
          vol: ticker[:volume],
          trend: ticker[:trend],
          change: ticker[:change],
          change_trend: ticker[:change_trend]
        }
      }
    end

  end
end
