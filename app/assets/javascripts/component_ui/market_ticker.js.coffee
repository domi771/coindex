window.MarketTickerUI = flight.component ->
  @defaultAttrs
    volumeSelector: '.value.volume'
    changeSelector: '.value.change'
    changetrendSelector: '.value.changetrend'
    changetrendSelector2: '.value.change'
    askPriceSelector: '.value.sell'
    bidPriceSelector: '.value.buy'
    lowPriceSelector: '.value.low'
    highPriceSelector: '.value.high'
    latestPriceSelector: '.value.last'
    trendSelector: '.value.trend'
    trendSelector2: '.value.last'

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

  @updateTrend = (text) ->
    el = @select('trendSelector')
    el.removeClass('up-arrow').removeClass('down-arrow')

    if text is 'up'
      el.addClass('up-arrow').fadeIn()
    else
      el.addClass('down-arrow').fadeIn()

  @updateTrend2 = (text) ->
    el = @select('trendSelector2')
    el.removeClass('up').removeClass('down')

    if text is 'up'
      el.addClass('up')
    else
      el.addClass('down')

  @updatechangetrend = (text) ->
    el = @select('changetrendSelector')
    el.removeClass('up-arrow').removeClass('down-arrow')

    if text is 'up'
      el.addClass('up-arrow').fadeIn()
    else
      el.addClass('down-arrow').fadeIn()

  @updatechangetrend2 = (text) ->
    el = @select('changetrendSelector2')
    el.removeClass('up').removeClass('down')

    if text is 'up'
      el.addClass('up')
    else
      el.addClass('down')


  @refresh = (event, data) ->
    @select('volumeSelector').text round(data.volume, gon.market.ask.fixed)
    @select('changeSelector').text ((data.change * 100) / 100).toFixed(2)

    @update @select('askPriceSelector'), data.sell
    @update @select('bidPriceSelector'), data.buy
    @update @select('lowPriceSelector'), data.low
    @update @select('highPriceSelector'), data.high
    @update @select('latestPriceSelector'), data.last
    @updateTrend data.trend
    @updateTrend2 data.trend
    @updatechangetrend data.change_trend
    @updatechangetrend2 data.change_trend

    document.title = "(#{data.last}) #{gon.market.id.toUpperCase()}"

  @after 'initialize', ->
    @refresh 'market::ticker', gon.ticker
    @on document, 'market::ticker', @refresh
