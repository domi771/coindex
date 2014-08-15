class Ohlc < ActiveRecord::Base
  extend ActiveHash::Associations::ActiveRecordExtensions
  ZERO = '0.0'.to_d

  extend Enumerize
#  enumerize :trend, in: {:up => 1, :down => 0}

  enumerize :currency, in: Market.enumerize, scope: true
  belongs_to :market, class_name: 'Market', foreign_key: 'currency'

  attr_accessor :side

  def sn
    "##{id}"
  end

    def filter(market)
      ohlcs = with_currency(market)
      ohlcs
    end

    def for_member(currency)
      ohlcs = filter(currency).order(:mydate).reverse_order.limit(10000)
    end


  def for_notify(kind=nil)
    {
      id:     id,
      kind:   kind || side,
      at:     created_at.to_i,
      price:  price.to_s  || ZERO,
      volume: volume.to_s || ZERO
    }
  end

  def for_global
    { date: mydate.to_i,
      high: myhigh.to_s || ZERO,
      open: myopen.to_s || ZERO,
      low: mylow.to_s || ZERO,
      close: myclose.to_s || ZERO,
      amount: volume.to_s || ZERO }
  end

end

