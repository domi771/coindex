@PlaceOrderUI = flight.component ->
  @defaultAttrs
    formSel: 'form'
    successSel: '.status span.label-success'
    successSelinfo: '.status span.label-success-info'
    infoSel: '.status span.label-info'
    dangerSel: '.status span.label-danger'
    priceAlertSel: '.price-alert span.label-warning'
    balanceAlertSel: '.balance-alert span.label-danger'
    balanceWarningSel: '.balance-warning span.label-warning'

    priceSel: 'input[id$=price]'
    volumeSel: 'input[id$=volume]'
    sumSel: 'input[id$=total]'

    lastPrice: '.last-price .value'
    currentBalanceSel: '.current-balance .value'
    submitButton: ':submit'

  @panelType = ->
    switch @$node.attr('id')
      when 'bid_panel' then 'bid'
      when 'ask_panel' then 'ask'

  @cleanMsg = ->
    $(".label-warning").text('')
    $(".label-danger").text('')

  @resetForm = ->
    $('#order_bid_price').val('')
    $('#order_ask_price').val('')
    $('#order_bid_origin_volume').val('')
    $('#order_ask_origin_volume').val('')
    $('#order_bid_total').val('')
    $('#order_ask_total').val('')
    $('.btn-block').addClass('disabled').attr('disabled', 'disabled')

  @disableSubmit = ->
    @select('submitButton').addClass('disabled').attr('disabled', 'disabled')

  @enableSubmit = ->
    @select('submitButton').removeClass('disabled').removeAttr('disabled')

  @beforeSend = (event, jqXHR) ->
    @disableSubmit()

  @handleSuccess = (event, data) ->
    suctext = gon.i18n.place_order.price + ": " + data.price + " - " + gon.i18n.place_order.volume + ": " + data.volume + " - Total: " + data.total

    @cleanMsg()
    @select('successSel').text(data.message).show().fadeOut(10500)
    @select('successSelinfo').text(suctext).show().fadeOut(10500)
    @resetForm()
    @disableSubmit()

  @handleError = (event, data) ->
    @cleanMsg()
    json = JSON.parse(data.responseText)
    @select('dangerSel').text(json.message).show().fadeOut(5500)
    @enableSubmit()


  @computeSum = (event) ->
    if @select('priceSel').val() and @select('volumeSel').val()

      target = event.target
      if not @select('priceSel').is(target)
        @select('priceSel').fixBid()
      if not @select('volumeSel').is(target)
        @select('volumeSel').fixAsk()

      type = @panelType()
      price  = BigNumber(@select('priceSel').val())
      volume = BigNumber(@select('volumeSel').val())
      sum_no = price.times(volume)
      switch type
        when 'bid'
          fee = sum_no.times(0.0025)
          sum = sum_no.plus(fee)
        when 'ask'
          fee = sum_no.times(0.0025)
          sum = sum_no.minus(fee)

      @select('sumSel').val(sum).fixBid()
      @trigger 'updateAvailable', {sum: sum, volume: volume}

  @computeVolume = (event) ->
    if @.select('priceSel').val() and @.select('sumSel').val()

      target = event.target
      if not @select('priceSel').is(target)
        @select('priceSel').fixBid()
      if not @select('sumSel').is(target)
        @select('sumSel').fixAsk()

      sum    = BigNumber(@select('sumSel').val())
      price  = BigNumber(@select('priceSel').val())
      # volume = sum.dividedBy(price)
      volume = BigNumber(@select('volumeSel').val())

      @select('volumeSel').val(volume).fixAsk()
      @trigger 'updateAvailable', {sum: sum, volume: volume}

  @orderPlan = (event, data) ->
    return unless (@.$node.is(":visible"))
    @select('priceSel').val(data.price)
    @select('volumeSel').val(data.volume)
    @computeSum(event)

  @refreshBalance = (event, data) ->
    type = @panelType()
    balance = data[type].balance
    @select('currentBalanceSel').data('balance', balance)
    switch type
      when 'bid'
        @select('currentBalanceSel').text(balance).fixBid()
      when 'ask'
        @select('currentBalanceSel').text(balance).fixAsk()

  @updateAvailable = (event, data) ->
    type = @panelType()
    node = @select('currentBalanceSel')
    balance = BigNumber(node.data('balance'))
    switch type
      when 'bid'
        node.text(balance - data.sum).fixBid()
      when 'ask'
        node.text(balance - data.volume).fixAsk()

  @updateLastPrice = (event, data) ->
    @select('lastPrice').text data.last

  @copyLastPrice = ->
    lastPrice = @select('lastPrice').text().trim()
    @select('priceSel').val(lastPrice).focus()

  @balancePRECheck = (event, data) ->
    type = @panelType()
    node = @select('currentBalanceSel')
    volume = Number @select('volumeSel').val()
    balanceAlert = @select('balanceAlertSel')
    balanceWarning = @select('balanceWarningSel')
    switch type
      when 'bid'
        if volume <= 0
          balanceAlert.text ''
          @disableSubmit()
        else
          @balanceCheck()
      when 'ask'
        if volume <= 0
          balanceAlert.text ''
          @disableSubmit()
        else
          @balanceCheck()



  @balanceCheck = (event, data) ->
    type = @panelType()
    node = @select('currentBalanceSel')
    balance = BigNumber(node.data('balance'))
    volume = Number @select('volumeSel').val()
    sum = Number @select('sumSel').val()
    balanceAlert = @select('balanceAlertSel')
    balanceWarning = @select('balanceWarningSel')
    switch type
      when 'bid'
        if volume <= 0
          balanceWarning.text gon.i18n.place_order.min_unit
          balanceAlert.text ''
          @disableSubmit()
        else if (balance - sum) < 0
          balanceWarning.text ''
          balanceAlert.text gon.i18n.place_order.balance_low
          @disableSubmit()
        else
          balanceAlert.text ''
          balanceWarning.text ''
          @enableSubmit()
          @pricePRECheck()
      when 'ask'
        if volume <= 0
          balanceAlert.text ''
          balanceWarning.text gon.i18n.place_order.min_unit
          @disableSubmit()
        else if (balance - volume) < 0
          balanceWarning.text ''
          balanceAlert.text gon.i18n.place_order.balance_low
          @disableSubmit()
        else
          balanceAlert.text ''
          balanceWarning.text ''
          @enableSubmit()
          @pricePRECheck()


  @pricePRECheck = (event, data) ->
    type = @panelType()
    currentPrice = Number @select('priceSel').val()
    switch type
      when 'ask'
        if currentPrice <= 0
          @disableSubmit()
    switch type
      when 'bid'
        if currentPrice <= 0
          @disableSubmit()


  @priceCheck = (event, data) ->
    type = @panelType()
    currentPrice = Number @select('priceSel').val()
    lastPrice = Number gon.ticker.last
    priceAlert = @select('priceAlertSel')
    switch type
      when 'ask'
        if currentPrice <= 0
          priceAlert.text gon.i18n.place_order.min_price
          @disableSubmit()
        else if currentPrice > (lastPrice * 1.5)
          priceAlert.text gon.i18n.place_order.price_high
          @enableSubmit()
          @balancePRECheck()
        else if currentPrice < (lastPrice * 0.5)
          priceAlert.text gon.i18n.place_order.price_low
          @enableSubmit()
          @balancePRECheck()
        else
          priceAlert.text ''
          @enableSubmit()
          @balancePRECheck()
      when 'bid'
        if currentPrice <= 0
          priceAlert.text gon.i18n.place_order.min_price
          @disableSubmit()
        else if currentPrice > (lastPrice * 1.5)
          priceAlert.text gon.i18n.place_order.price_high
          @enableSubmit()
          @balancePRECheck()
        else if currentPrice < (lastPrice * 0.5)
          priceAlert.text gon.i18n.place_order.price_low
          @enableSubmit()
          @balancePRECheck()
        else
          priceAlert.text ''
          @enableSubmit()
          @balancePRECheck()


  @checkNumber = (event, data) ->

    # $("input").keypress (e) ->
    $('#order_ask_price').keypress (e) ->
      a = []
      k = e.which
      i = 48
      while i < 58
        a.push i
        i++
      a.push(46);
      a.push(8);
      a.push(9);
      a.push(13);
      e.preventDefault()  unless a.indexOf(k) >= 0
      return

    $('#order_bid_price').keypress (e) ->
      a = []
      k = e.which
      i = 48
      while i < 58
        a.push i
        i++
      a.push(46);
      a.push(8);
      a.push(9);
      a.push(13);
      e.preventDefault()  unless a.indexOf(k) >= 0
      return

    $('#order_bid_origin_volume').keypress (e) ->
      a = []
      k = e.which
      i = 48
      while i < 58
        a.push i
        i++
      a.push(46);
      a.push(8);
      a.push(9);
      a.push(13);
      e.preventDefault()  unless a.indexOf(k) >= 0
      return

    $('#order_ask_origin_volume').keypress (e) ->
      a = []
      k = e.which
      i = 48
      while i < 58
        a.push i
        i++
      a.push(46);
      a.push(8);
      a.push(9);
      a.push(13);
      e.preventDefault()  unless a.indexOf(k) >= 0
      return

  @after 'initialize', ->
    @on document, 'order::plan', @orderPlan
    @on document, 'price::check', @priceCheck
    @on document, 'balance::check', @balanceCheck

    @on document, 'market::ticker', @updateLastPrice
    @on 'updateAvailable', @updateAvailable

    @on document, 'trade::account', @refreshBalance
    @on @select('lastPrice'), 'click', @copyLastPrice
    @updateLastPrice 'market::ticker', gon.ticker

    @on @select('formSel'), 'ajax:beforeSend', @beforeSend
    @on @select('formSel'), 'ajax:success', @handleSuccess
    @on @select('formSel'), 'ajax:error', @handleError

    @on @select('priceSel'), 'keydown', @checkNumber
    @on @select('priceSel'), 'change paste keyup focusout', @priceCheck
    @on @select('priceSel'), 'change paste keyup focusout', @computeSum
    @on @select('volumeSel'), 'keydown', @checkNumber
    @on @select('volumeSel'), 'change paste keyup focusout', @computeSum
    @on @select('volumeSel'), 'change paste keyup focusout', @balanceCheck
    @on @select('sumSel'), 'change paste keyup', @computeVolume

