window.WelcomeUI = flight.component ->
  @defaultAttrs
    table: 'tbody'
    filter: '.dropdown-menu a'

  @refresh = (data) ->
    $table = @select('table')
    $table.append data.markets

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
      for key of data
        markets.push key if data.hasOwnProperty(key)
        markets.push key if data.hasOwnProperty(key)
        markets.push data[key].ticker.vol
        markets.push data[key].ticker.change
        markets.push data[key].ticker.last
        markets.push data[key].ticker.high
        markets.push data[key].ticker.low
      console.log markets

    setInterval (->
      $.getJSON "/api/v2/tickers", (data) ->

        markets = []
        dataLength = data.length
        i = 0
        
        for key of data
          markets.push key if data.hasOwnProperty(key)
          markets.push key if data.hasOwnProperty(key)
          markets.push data[key].ticker.vol
          markets.push data[key].ticker.change
          markets.push data[key].ticker.last
          markets.push data[key].ticker.high
          markets.push data[key].ticker.low

        console.log markets
    ), 50000000
    
    markets = [{"market":"ltcbtc","currency":"ltc","volume":"2.009","change":"12.5","last":"0.34","high":"0.43","low":"0.23"},{"market":"viabtc","currency":"via","volume":"14.04","change":"-10","last":"0.0034","high":"0.004","low":"0.003"}]

    markets.sort (a, b)->
      a.vol - b.vol

    @refresh {markets: markets}

    @initList()

    @on @select('filter'), 'click', @filter
