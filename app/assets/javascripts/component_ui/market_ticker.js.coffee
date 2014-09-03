window.MarketTickerUI = flight.component ->
  @defaultAttrs
    volumeSelector: '.value.volume'
    askPriceSelector: '.value.sell'
    bidPriceSelector: '.value.buy'
    lowPriceSelector: '.value.low'
    highPriceSelector: '.value.high'
    latestPriceSelector: '.value.last'
    trendSelector: '.value.trend'

  @update = (el, text) ->
    if isNaN(text)
      if el.text() isnt text
        el.fadeOut ->
          el.text(text).fadeIn()
    else
      text = round(text, gon.market.bid.fixed)
      if el.text() isnt text
        el.fadeOut ->
          el.text(text).fadeIn()

  @refresh = (event, data) ->
    @select('volumeSelector').text round(data.volume, gon.market.ask.fixed)

    @update @select('askPriceSelector'), data.sell
    @update @select('bidPriceSelector'), data.buy
    @update @select('lowPriceSelector'), data.low
    @update @select('highPriceSelector'), data.high
    @update @select('latestPriceSelector'), data.last
    @update @select('trendSelector'), data.trend

    document.title = "(#{data.last}) #{gon.market.id.toUpperCase()}"

  @after 'initialize', ->
    @refresh 'market::ticker', gon.ticker
    @on document, 'market::ticker', @refresh
