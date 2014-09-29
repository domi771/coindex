window.AccountsUI = flight.component ->
  @defaultAttrs
    table: 'tbody'
    filter: '.dropdown-menu a'
    total_btc: '.total_btc .value'

  @refresh = (data) ->
    $table = @select('table')
    $table.prepend(JST['account'](account)) for account in data.accounts
    @select('total_btc').text(fixAsk data.total_btc)

    getStstus = localStorage.getItem("zerobalance")
    if getStstus is "true"
      document.getElementById("filterCheckBox").setAttribute "checked", "checked"
      $(".searchable tr").hide()
      $(".searchable tr").filter(->
        $(this).find("td").eq(4).text() isnt "0.00000000"
      ).show()
      $(".no-data").hide()
      $(".no-data").show()  if $(".searchable tr:visible").length is 0
      localStorage.setItem "zerobalance", "true"
    else
      $(".searchable tr").show()
      $(".no-data").hide()
      localStorage.setItem "zerobalance", "false"


  @filter = (event) ->
    type = event.target.className
    return @list.filter() if type == ''

    @list.filter (item) ->
      item.values().type == "#{gon.i18n[type]}"

  @initList = ->
    options =
      valueNames: [ 'code', 'currency', 'available', 'locked', 'total', 'est_btc', 'change']
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
        accounts2.push item
            
        while i < accounts2.length
          obj2[accounts2[i].currency] = accounts2[i]
          i++

      accounts = []
      for key of obj1
        accounts.push merge_options(obj1[key], obj2[key])
   
      
      i = 0
      total = BigNumber(0)
      while i < accounts.length
        accounts[i].est_btc = accounts[i].last * (BigNumber(accounts[i].available).plus(accounts[i].locked))
        if isNaN parseFloat(accounts[i].est_btc) 
          accounts[i].est_btc = BigNumber(accounts[i].available).plus(accounts[i].locked)
        accounts[i].total = BigNumber(accounts[i].available).plus(accounts[i].locked)
        total = total.plus(accounts[i].est_btc)
        i++

      # console.log total

      total_btc =  BigNumber(total)
      # total_btc =  total

      accounts.sort (a, b)->
        # a.currency < b.currency
        b.currency.localeCompare(a.currency)

      # console.log accounts


      @refresh {accounts: accounts, total_btc: total_btc}
   
      @initList()

      @on @select('filter'), 'click', @filter


