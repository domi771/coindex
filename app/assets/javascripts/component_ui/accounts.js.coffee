window.AccountsUI = flight.component ->
  @defaultAttrs
    table: 'tbody'
    filter: '.dropdown-menu a'

  @refresh = (data) ->
    $table = @select('table')
    $table.prepend(JST['account'](account)) for account in data.accounts

  @filter = (event) ->
    type = event.target.className
    return @list.filter() if type == ''

    @list.filter (item) ->
      item.values().type == "#{gon.i18n[type]}"

  @initList = ->
    options =
      valueNames: [ 'code', 'currency', 'available', 'locked' ]
    @list = new List('accounts', options)

  @after 'initialize', ->
    # accounts = gon.accounts

    $.ajax
      url: "/api/v2/tickers"
      success: (data, status, XHR) ->
        handleData data
        return

    handleData = (data) =>
      accounts = gon.accounts

      for own cur of data
        ticker = data[cur].ticker
        item = {}
        [
          "change"
          "last"
        ].forEach (key) ->
          item[key] = ticker[key]
          return

        item.currency = cur.substring(3)
        # accounts.push item

      accounts.sort (a, b)->
        a.currency < b.currency
      @refresh {accounts: accounts}

      @initList()

      @on @select('filter'), 'click', @filter


