window.AccountsUI = flight.component ->
  @defaultAttrs
    table: 'tbody'
    filter: '.dropdown-menu a'
    total_btc: '.total_btc .value'

  @refresh = (data) ->
    $table = @select('table')
    $table.prepend(JST['account'](account)) for account in data.accounts
    @select('total_btc').text(fixAsk data.total_btc)

    checkZero = (currentTr) ->
      if $("#filter2").is(":checked")
        $(currentTr).find("td").eq(4).text() isnt "0.00000000"
      else
        true
    getStstus = localStorage.getItem("zerobalance")
    if getStstus is "true"
      document.getElementById("filter2").setAttribute "checked", "checked"
      $(".searchable tr").hide()
      $(".searchable tr").filter(->
        checkZero(this)
      ).show()
      $(".no-data").hide()
      $(".no-data").show()  if $(".searchable tr:visible").length is 0
    else
      # localStorage.setItem "zerobalance", "false"
      $(".searchable tr").filter(->
        matchesSearch this
      ).show()
      $(".no-data").hide()
      $(".no-data").show()  if $(".searchable tr:visible").length is 0


  @filter = (event) ->
    type = event.target.className
    return @list.filter() if type == ''

    @list.filter (item) ->
      item.values().type == "#{gon.i18n[type]}"

  @initList = ->
    options =
      valueNames: [ 'code', 'currency', 'available', 'locked', 'est_btc', 'change']
    @list = new List('accounts', options)

  @after 'initialize', ->
    # accounts = gon.accounts

    $.ajax
      url: "/api/v2/tickers"
      success: (data, status, XHR) ->
        handleData data
        return

    handleData = (data) =>
      accounts1 = gon.accounts
      

      merge_options = (obj1, obj2) ->
        obj3 = {}
        for attrname of obj1
          obj3[attrname] = obj1[attrname]
        for attrname of obj2
          obj3[attrname] = obj2[attrname]
        obj3
      obj1 = []
      i = 0

      while i < accounts1.length
        obj1[accounts1[i].code] = accounts1[i]
        i++
      obj2 = []
      i = 0

      accounts2 = []

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
        item.merge = cur.substring(3)
        accounts2.push item
            
        while i < accounts2.length
          obj2[accounts2[i].merge] = accounts2[i]
          i++

      accounts = []
      for key of obj1
        accounts.push merge_options(obj2[key], obj1[key])
   
      
      i = 0
      total = BigNumber(0)
      while i < accounts.length
        accounts[i].est_btc = accounts[i].last * (BigNumber(accounts[i].available).plus(accounts[i].locked))
        if isNaN parseFloat(accounts[i].est_btc) 
          accounts[i].est_btc = BigNumber(accounts[i].available).plus(accounts[i].locked)
        accounts[i].total = BigNumber(accounts[i].available).plus(accounts[i].locked)
        total = total.plus(accounts[i].est_btc)
        i++


      total_btc =  BigNumber(total)

      accounts.sort (a, b)->
        #a.currency < b.currency
        b.currency.localeCompare(a.currency)

      # console.log accounts
      # console.log accounts1
      # console.log accounts2


      @refresh {accounts: accounts, total_btc: total_btc}
   
      @initList()

      @on @select('filter'), 'click', @filter


