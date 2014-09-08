module APIv2
  class Markets < Grape::API
    helpers ::APIv2::NamedParams

    desc 'Get all available markets.'
    get "/markets" do
      present Market.all, with: APIv2::Entities::Market
    end


    get "/markets_ticker" do

      hashes = [ { "attributes" => { "id" => "usdeur", "code" => 4 },
             "name"       => "USD/EUR"
           },
           { "attributes" => { "id" => "eurgbp", "code" => 5 },
             "name"       => "EUR/GBP"
           } ] 

      xx = hashes.map {|hash| hash["attributes"]["id"] }
      xx.each do |i|
       p i
      end

     
     

    end
  end
end


