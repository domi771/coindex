window.MarketsUI = flight.component ->
  @defaultAttrs
    table: 'tbody'
    filter: '.dropdown-menu a'

  @refresh = (data) ->
    $table = @select('table')
    $table.prepend(JST['market'](market)) for market in data.markets
    console.log data.markets

  @filter = (event) ->
    type = event.target.className
    return @list.filter() if type == ''

    @list.filter (item) ->
      item.values().type == "#{gon.i18n[type]}"

  @initList = ->
    options =
      valueNames: [ 'market', 'currency', 'vol', 'change',
      'last', 'high', 'low']
    @list = new List('marketsX', options)

  @after 'initialize', ->

    markets = []
    $.getJSON "/api/v2/tickers", (data) ->
      markets = []
      for cur of data
        ticker = data[cur].ticker
        item = {}
        [
          "change"
          "change_trend"
          "last"
          "high"
          "low"
        ].forEach (key) ->
          item[key] = ticker[key]
          return

        item.volume = ticker.vol
        item.market = cur
        item.currency = cur.substring(3)
        markets.push item
        console.log markets

    setInterval (->
       markets = []
       $.getJSON "/api/v2/tickers", (data) ->
         markets = []
         for cur of data
           ticker = data[cur].ticker
           item = {}
           [
             "change"
             "change_trend"
             "last"
             "high"
             "low"
           ].forEach (key) ->
             item[key] = ticker[key]
             return

           item.volume = ticker.vol
           item.market = cur
           item.currency = cur.substring(3)
           markets.push item
           console.log markets
    ), 5000

    markets = [{"market":"ltcbtc","currency":"ltc","volume":"2.009","change":"12.5","last":"0.34","high":"0.43","low":"0.23","change_trend":"down"},{"market":"viabtc","currency":"via","volume":"14.04","change":"-10","last":"0.34","high":"0.43","low":"0.23","change_trend":"up"}]
    markets.sort (a, b)->
       a.volume - b.volume

    @refresh {markets: markets}

    @initList()

    @on @select('filter'), 'click', @filter
