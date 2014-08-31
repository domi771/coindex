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
end
