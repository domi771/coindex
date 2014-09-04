module APIv2
  class Markets < Grape::API
    helpers ::APIv2::NamedParams

    desc 'Get all available markets.'
    get "/markets" do
      present Market.all, with: APIv2::Entities::Market
    end

    params do
      #use :Market.all, with: APIv2::Entities::Market_Ticker
      use :market
    end

    get "/markets_ticker" do

      # present Market.all, with: APIv2::Entities::Market
      present Market.all, with: APIv2::Entities::Market

      # ticker = Global[params[:market]].ticker
      # present ticker
      
      #present Market.all.select{|t| t == id.ticker} with: APIv2::Entities::Marke
     #Market.all.each do |t|
     # ticker = t.id
     # present ticker
     #end


     # Token.all.each do |t|
     # id = Member.find_by_identity_id(t.member_id)
     # t.update_column :member_id, id
     # end
     
     # ticker = Global[params[:market]].ticker

     # { at: ticker[:at],
     #   ticker: {
     #     buy: ticker[:buy],
     #     sell: ticker[:sell],
     #     low: ticker[:low],
     #     high: ticker[:high],
     #     last: ticker[:last],
     #     vol: ticker[:volume],
     #     trend: ticker[:trend]
     #   }
     # }

#     present Market.all, with: APIv2::Entities::Market_Ticker
     
     

    end
  end
end


