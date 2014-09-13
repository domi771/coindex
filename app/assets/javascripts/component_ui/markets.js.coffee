window.MarketsUI = flight.component ->
  @defaultAttrs
    table: 'tbody'
    filter: '.dropdown-menu a'

  @refresh = (data) ->
    $table = @select('table')
    $table.empty()
    $table.prepend(JST['market'](market)) for market in data.markets

  @filter = (event) ->
    type = event.target.className
    return @list.filter() if type == ''

    @list.filter (item) ->
      item.values().type == "#{gon.i18n[type]}"

  @initList = ->
    options =
      valueNames: [ 'market', 'currency', 'volume', 'change',
      'last', 'high', 'low']
    @list = new List('markets', options)

  @after 'initialize', ->
 
    $.ajax
      url: "/api/v2/tickers"
      success: (data, status, XHR) ->
        handleData data
        return

    handleData = (data) =>
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
        item.market = cur.substring(0, 3) + "/" + cur.substring(3)
        item.market_link = cur
        item.currency = cur.substring(0, 3)
        markets.push item

      markets.sort (a, b)->
        a.volume - b.volume
      document.getElementById("markets-loading").style.display = "none"      
      document.getElementById("markets-all").style.display = "block"

      @refresh {markets: markets}
      @initList() 
      @on @select('filter'), 'click', @filter
      return


    setInterval (=>

      $.ajax
        url: "/api/v2/tickers"
        success: (data, status, XHR) ->
          handleData data
          return

      handleData = (data) =>
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
          item.market = cur.substring(0, 3) + "/" + cur.substring(3)
          item.market_link = cur
          item.currency = cur.substring(0, 3)
          markets.push item

        markets.sort (a, b)->
          a.volume - b.volume

        @refresh {markets: markets}
        @initList()
        @on @select('filter'), 'click', @filter
        return


    ), 30000
