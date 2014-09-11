json.markets @markets do |market|
  json.market market.market
  json.currency market.currency
  json.volume market.volume
  json.change market.change
  json.last market.last
  json.high market.high
  json.low market.low
end

json.i18n do
  json.brand I18n.t('gon.brand')
end


