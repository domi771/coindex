window.MarketsUI = flight.component ->
  @defaultAttrs
    table: 'tbody'
    filter: '.dropdown-menu a'

  @refresh = (data) ->
    $table = @select('table')
    $table.prepend(JST['market'](market)) for market in data.markets
    console.log data.markets
    console.log markets


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


    $.getJSON "/api/v2/tickers", (data) ->

      markets = []
      for own cur of data
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
      #return

      markets.sort (a, b)->
        a.volume - b.volume

      @refresh {markets: markets}

      @initList()

      @on @select('filter'), 'click', @filter


