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
          change: ticker[:change]
        }
      }
    end

    get "/tickers_all" do

    #a1 = ["some", "thing"]
    #a2 = ["another", "thing"]

    a1 = ["ltcbtc"]
    a2 = json

    a1.concat a2
    present a1
    end


  end
end
