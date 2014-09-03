@PlaceOrderUI = flight.component ->
  @defaultAttrs
    formSel: 'form'
    successSel: '.status span.label-success'
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
    @select('successSel').text('')
    @select('infoSel').text('')
    @select('dangerSel').text('')

  @resetForm = (event) ->
    @select('volumeSel') BigNumber(0)
    @select('sumSel') BigNumber(0)

  @disableSubmit = ->
    @select('submitButton').addClass('disabled').attr('disabled', 'disabled')

  @enableSubmit = ->
    @select('submitButton').removeClass('disabled').removeAttr('disabled')

  @confirmDialogMsg = ->
    confirmType = @select('submitButton').text()
    price = @select('priceSel').val()
    volume = @select('volumeSel').val()
    sum = @select('sumSel').val()
    """
    #{gon.i18n.place_order.confirm_submit} "#{confirmType}"?

    #{gon.i18n.place_order.price}: #{price}
    #{gon.i18n.place_order.volume}: #{volume}
    #{gon.i18n.place_order.sum}: #{sum}
    """

  @beforeSend = (event, jqXHR) ->
    if confirm(@confirmDialogMsg())
      @disableSubmit()
    else
      jqXHR.abort()

  @handleSuccess = (event, data) ->
    @cleanMsg()
    @select('successSel').text(data.message).show().fadeOut(5500)
    @resetForm(event)
    @enableSubmit()

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

      price  = BigNumber(@select('priceSel').val())
      volume = BigNumber(@select('volumeSel').val())
      sum    = price.times(volume)

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
      volume = sum.dividedBy(price)

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
          @balanceCheck()
        else if currentPrice < (lastPrice * 0.5)
          priceAlert.text gon.i18n.place_order.price_low
          @enableSubmit()
          @balanceCheck()
        else
          priceAlert.text ''
          @enableSubmit()
          @balanceCheck()
      when 'bid'
        if currentPrice <= 0
          priceAlert.text gon.i18n.place_order.min_price
          @disableSubmit()
        else if currentPrice > (lastPrice * 1.5)
          priceAlert.text gon.i18n.place_order.price_high
          @enableSubmit()
          @balanceCheck()
        else if currentPrice < (lastPrice * 0.5)
          priceAlert.text gon.i18n.place_order.price_low
          @enableSubmit()
          @balanceCheck()
        else
          priceAlert.text ''
          @enableSubmit()
          @balanceCheck()


  @checkNumber = (event, data) ->

    $("input").keypress (e) ->
      a = []
      k = e.which
      i = 48
      while i < 58
        a.push i
        i++
      a.push(46);
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

