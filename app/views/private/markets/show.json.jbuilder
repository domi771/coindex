json.ask @ask
json.bid @bid
json.asks @asks
json.bids @bids
json.trades @trades
json.ticker @ticker

json.i18n do
  json.brand I18n.t('gon.brand')
  json.ask I18n.t('gon.ask')
  json.bid I18n.t('gon.bid')
  json.cancel I18n.t('actions.cancel')
  json.chart_price I18n.t('chart.price')
  json.chart_volume I18n.t('chart.volume')
  json.place_order do |place_order|
    place_order.confirm_submit I18n.t('private.markets.show.confirm')
    place_order.price I18n.t('private.markets.place_order.price')
    place_order.volume I18n.t('private.markets.place_order.amount')
    place_order.sum I18n.t('private.markets.place_order.total')
    place_order.subtotal I18n.t('private.markets.place_order.subtotal')
    place_order.fee I18n.t('private.markets.place_order.fee')
    place_order.price_high I18n.t('private.markets.place_order.price_high')
    place_order.price_low I18n.t('private.markets.place_order.price_low')
    place_order.balance_low I18n.t('private.markets.place_order.balance_low')
    place_order.min_price I18n.t('private.markets.place_order.min_price')
    place_order.min_unit I18n.t('private.markets.place_order.min_unit')
    place_order.subtotal I18n.t('private.markets.place_order.subtotal')
    place_order.disclaimer_header I18n.t('private.markets.place_order.disclaimer_header')
    place_order.disclaimer_body I18n.t('private.markets.place_order.disclaimer_body')
    place_order.market I18n.t('private.markets.place_order.market')
    place_order.confirm_buy_title I18n.t('private.markets.place_order.confirm_buy_title')
    place_order.confirm_sell_title I18n.t('private.markets.place_order.confirm_sell_title')
    place_order.confirm_total I18n.t('private.markets.place_order.confirm_total')
    place_order.type I18n.t('private.markets.place_order.type')
    place_order.type_buy I18n.t('private.markets.place_order.type_buy')
    place_order.type_sell I18n.t('private.markets.place_order.type_sell')
    place_order.cancel I18n.t('private.markets.place_order.cancel')
    place_order.confirm I18n.t('private.markets.place_order.confirm')
  end
end

json.accounts do
  json.set! @ask, 'ask'
  json.set! @bid, 'bid'
  json.ask do json.(@member.get_account(@ask), :balance, :locked, :currency) end
  json.bid do json.(@member.get_account(@bid), :balance, :locked, :currency) end
end

json.orders do
  json.wait *([@orders_wait] + Order::ATTRIBUTES)
  json.done @trades_done.map {|t|
    if t.self_trade?
      [t.for_notify('ask'), t.for_notify('bid')]
    else
      t.for_notify
    end
  }.flatten
  json.cancel *([@orders_cancel] + Order::ATTRIBUTES)
end

