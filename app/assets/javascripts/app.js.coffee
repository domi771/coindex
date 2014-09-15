@App =
  showInfo:   (msg) -> $(document).trigger 'flash-info',   msg: msg
  showNotice: (msg) -> $(document).trigger 'flash-notice', msg: msg
  showAlert:  (msg) -> $(document).trigger 'flash-alert',  msg: msg

$ ->
  if $('#assets-index').length
    $.scrollIt
      topOffset: -180
      activeClass: 'active'

    $('a.go-verify').on 'click', (e) ->
      e.preventDefault()

      root         = $('.tab-pane.active .root.json pre').text()
      partial_tree = $('.tab-pane.active .partial-tree.json pre').text()

      if partial_tree
        uri = 'http://syskall.com/proof-of-liabilities/#verify?partial_tree=' + partial_tree + '&expected_root=' + root
        window.open(encodeURI(uri), '_blank')

  $('[data-clipboard-text], [data-clipboard-target]').each ->
    zero = new ZeroClipboard $(@), forceHandCursor: true

    zero.on 'complete', ->
      $(zero.htmlBridge)
        .attr('title', gon.clipboard.done)
        .tooltip('fixTitle')
        .tooltip('show')
    zero.on 'mouseout', ->
      $(zero.htmlBridge)
        .attr('title', gon.clipboard.click)
        .tooltip('fixTitle')

    placement = $(@).data('placement') || 'bottom'
    $(zero.htmlBridge).tooltip({title: gon.clipboard.click, placement: placement})

  $('.qrcode-container').each (index, el) ->
    $el = $(el)
    new QRCode el,
      text:   $el.data('text')
      width:  $el.data('width')
      height: $el.data('height')

  AccountBalanceUI.attachTo('.account-balance')
  PlaceOrderUI.attachTo('.place-order #bid_panel')
  PlaceOrderUI.attachTo('.place-order #ask_panel')
  MyOrdersWaitUI.attachTo('.my-orders #orders_wait')
  MyOrdersDoneUI.attachTo('.my-orders #orders_done')
  PushButton.attachTo('.place-order')
  PushButton.attachTo('.my-orders')

  # if gon.env is 'development'
  #   Pusher.log = (message) -> window.console && console.log(message)

  pusher = new Pusher gon.pusher_key, gon.pusher_options
  pusher.connection.bind 'state_change', (state) ->
    if state.current is 'unavailable'
      $('#markets-show .pusher-unavailable').removeClass('hide')

  GlobalData.attachTo(document, {pusher: pusher})
  MemberData.attachTo(document, {pusher: pusher}) if gon.accounts

  MarketTickerUI.attachTo('.ticker')
  MarketOrdersUI.attachTo('.orders')
  MarketTradesUI.attachTo('.trades')
  MarketChartUI.attachTo('.price-chart')
  OrderbookChartUI.attachTo('.orderbook-chart')
  BuysellratioChartUI.attachTo('.buysellratio-chart')

  TransactionsUI.attachTo('#transactions')
  MarketsUI.attachTo('#markets')
  VerifyMobileNumberUI.attachTo('#new_sms_token')
  FlashMessageUI.attachTo('.flash-message')
  TwoFactorAuth.attachTo('.two-factor-auth-container')

  $("a[data-toggle=\"tab\"]").on "shown.bs.tab", (e) ->
    $(window).resize()
    return
  
  $(window).on "resize", (event) ->
    $("#pricechart").hide().fadeIn 1000
    $("#orderbookchart").hide().fadeIn 1000
    toggle = true
    return

  # $('.tab-content').on 'mousewheel DOMMouseScroll', (e) ->
  #   $(@).scrollTop(@scrollTop + e.deltaY)
  #   e.preventDefault()


#$ ->
#  $("#buy_order_btn").click ->
#    bootbox.confirm "Are you sure?", (result) ->
#      if(result)
#        $("#new_order_bid").trigger "submit"
#        return
#   false

#$ ->
#  $("#sell_order_btn").click ->
#    bootbox.confirm "Are you sure?", (result) ->
#      if(result)
#        $("#new_order_ask").trigger "submit"
#        return
#    false

$ ->
  $("#buy_order_btn").click (e) =>
    e.preventDefault();
    bid = $("#market_bid").text()
    ask = $("#market_ask").text()
    market = bid + "/" + ask
    price = $("#order_bid_price").val()
    volume = $("#order_bid_origin_volume").val()
    sum = $("#order_bid_total").val()
    volume = parseFloat(volume).toFixed(8)
    sum_without_fee = (sum / 1.0025).toFixed(8)
    fee = sum - sum_without_fee
    fee = parseFloat(fee).toFixed(8)

    bootbox.dialog
      title: "Confirm Buy Order"
      message:      "<div class=\"row\" style=\"margin-bottom:10px\">" + "
                        <div class=\"col-sm-offset-1 col-sm-2\"><h4 style=\"font-weight:bold\">Type:</h4></div>" + "
                        <div class=\"col-sm-3\"><h4 data-bind=\"text:order.tradeType\">Limit Buy</h4></div>" + "
                        <div class=\"col-sm-2\"><h4 style=\"font-weight:bold\">Market:</h4></div>" + "
                        <div class=\"col-sm-3\"><h4>" + market + "</h4></div>" + "
                    </div>" + "
                    <div id=\"form-container\">" + "
                        <form role=\"form\" class=\"form-horizontal\">" + "
                            <div class=\"form-group\" style=\"margin-bottom:10px\">" + "
                                <h5 class=\"col-sm-offset-1 col-sm-3\">" + "
                                    Quantity:" + "
                                </h5>" + "
                                <div class=\"col-sm-7\">" + "
                                    <div class=\"input-group\">" + "
                                        <input class=\"form-control text-right\" type=\"text\" readonly=\"readonly\" value=\"" + volume + "\">" + "
                                        <span class=\"input-group-addon\">" + ask  + "</span>" + "
                                    </div>" + "
                                </div>" + "
                            </div>" + "
                            <div class=\"form-group\" style=\"margin-bottom:10px\">" + "
                                <h5 class=\"col-sm-offset-1 col-sm-3\">" + "
                                    Price:" + "
                                </h5>" + "
                                <div class=\"col-sm-7\">" + "
                                    <div class=\"input-group\">" + "
                                        <input class=\"form-control text-right\" type=\"text\" readonly=\"readonly\" value=\"" +price + "\">" + "
                                        <span class=\"input-group-addon\">" + bid  + "</span>" + "
                                    </div>" + "
                                </div>" + "
                            </div>" + "
                            <div class=\"form-group\" style=\"margin-bottom:10px\">" + "
                                <h5 class=\"col-sm-offset-1 col-sm-3\">" + "
                                    Subtotal:" + "
                                </h5>" + "
                                <div class=\"col-sm-7\">" + "
                                    <div class=\"input-group\">" + "
                                        <input class=\"form-control text-right\" data-bind=\"value: order.tradeSubTotal\" type=\"text\" readonly=\"readonly\" value=\"" + sum_without_fee + "\">" + "
                                        <span class=\"input-group-addon\">" + ask  + "</span>" + "
                                    </div>" + "
                                </div>" + "
                            </div>" + "
                            <div class=\"form-group\" style=\"margin-bottom:10px\">" + "
                                <h5 class=\"col-sm-offset-1 col-sm-3\">" + "
                                    Commission:" + "
                                </h5>" + "
                                <div class=\"col-sm-7\">" + "
                                    <div class=\"input-group\">" + "
                                        <input class=\"form-control text-right\" data-bind=\"value: order.tradeCommission\" type=\"text\" readonly=\"readonly\" value=\"" + fee + "\">" + "
                                        <span class=\"input-group-addon\">" + ask  + "</span>" + "
                                    </div>" + "
                                </div>" + "
                            </div>" + "
                            <div class=\"form-group\" style=\"margin-bottom:10px\">" + "
                                <h5 class=\"col-sm-offset-1 col-sm-3\">" + "
                                    Total:" + "
                                </h5>" + "
                                <div class=\"col-sm-7\">" + "
                                    <div class=\"input-group\">" + "
                                        <input class=\"form-control text-right\" data-bind=\"value: order.tradeTotal\" type=\"text\" readonly=\"readonly\" value=\"" + sum + "\">" + "
                                        <span class=\"input-group-addon\">" + ask  + "</span>" + "
                                    </div>" + "
                                </div>" + "
                            </div>" + "
                        </form>" + "
                    </div>" + "

                    <div data-bind=\"html: order.orderModalAlert\"></div>" + "
                    <div class=\"bs-callout bs-callout-warning\">" + "
                        <h4>Disclaimer</h4>" + "
                        <p>Please verify this order before confirming. All orders are final once submitted and we will be unable to issue you a refund.</p>" + "
                    </div>" + "
                </div>"
      buttons:
        cancel:
          label: "Cancel"
          className: "btn-primary"
        main:
          label: "Confirm"
          className: "btn-primary"
          callback: (result) ->
            if(result)
              $("#new_order_bid").trigger "submit"
              return


$ ->
  $("#sell_order_btn").click (e) =>
    e.preventDefault();
    bid = $("#market_bid").text()
    ask = $("#market_ask").text()
    market = bid + "/" + ask
    price = $("#order_bid_price").val()
    volume = $("#order_bid_origin_volume").val()
    sum = $("#order_bid_total").val()
    volume = parseFloat(volume).toFixed(8)
    sum_without_fee = (sum / 0.9975).toFixed(8)
    fee = sum_without_fee - sum
    fee = parseFloat(fee).toFixed(8)

    bootbox.dialog
      title: "Confirm Sell Order"
      message:      "<div class=\"row\" style=\"margin-bottom:10px\">" + "
                        <div class=\"col-sm-offset-1 col-sm-2\"><h4 style=\"font-weight:bold\">Type:</h4></div>" + "
                        <div class=\"col-sm-3\"><h4 data-bind=\"text:order.tradeType\">Limit Sell</h4></div>" + "
                        <div class=\"col-sm-2\"><h4 style=\"font-weight:bold\">Market:</h4></div>" + "
                        <div class=\"col-sm-3\"><h4>" + market + "</h4></div>" + "
                    </div>" + "
                    <div id=\"form-container\">" + "
                        <form role=\"form\" class=\"form-horizontal\">" + "
                            <div class=\"form-group\" style=\"margin-bottom:10px\">" + "
                                <h5 class=\"col-sm-offset-1 col-sm-3\">" + "
                                    Quantity:" + "
                                </h5>" + "
                                <div class=\"col-sm-7\">" + "
                                    <div class=\"input-group\">" + "
                                        <input class=\"form-control text-right\" type=\"text\" readonly=\"readonly\" value=\"" + volume + "\">" + "
                                        <span class=\"input-group-addon\">" + ask  + "</span>" + "
                                    </div>" + "
                                </div>" + "
                            </div>" + "
                            <div class=\"form-group\" style=\"margin-bottom:10px\">" + "
                                <h5 class=\"col-sm-offset-1 col-sm-3\">" + "
                                    Price:" + "
                                </h5>" + "
                                <div class=\"col-sm-7\">" + "
                                    <div class=\"input-group\">" + "
                                        <input class=\"form-control text-right\" type=\"text\" readonly=\"readonly\" value=\"" +price + "\">" + "
                                        <span class=\"input-group-addon\">" + bid  + "</span>" + "
                                    </div>" + "
                                </div>" + "
                            </div>" + "
                            <div class=\"form-group\" style=\"margin-bottom:10px\">" + "
                                <h5 class=\"col-sm-offset-1 col-sm-3\">" + "
                                    Subtotal:" + "
                                </h5>" + "
                                <div class=\"col-sm-7\">" + "
                                    <div class=\"input-group\">" + "
                                        <input class=\"form-control text-right\" data-bind=\"value: order.tradeSubTotal\" type=\"text\" readonly=\"readonly\" value=\"" + sum_without_fee + "\">" + "
                                        <span class=\"input-group-addon\">" + ask  + "</span>" + "
                                    </div>" + "
                                </div>" + "
                            </div>" + "
                            <div class=\"form-group\" style=\"margin-bottom:10px\">" + "
                                <h5 class=\"col-sm-offset-1 col-sm-3\">" + "
                                    Commission:" + "
                                </h5>" + "
                                <div class=\"col-sm-7\">" + "
                                    <div class=\"input-group\">" + "
                                        <input class=\"form-control text-right\" data-bind=\"value: order.tradeCommission\" type=\"text\" readonly=\"readonly\" value=\"" + fee + "\">" + "
                                        <span class=\"input-group-addon\">" + ask  + "</span>" + "
                                    </div>" + "
                                </div>" + "
                            </div>" + "
                            <div class=\"form-group\" style=\"margin-bottom:10px\">" + "
                                <h5 class=\"col-sm-offset-1 col-sm-3\">" + "
                                    Total:" + "
                                </h5>" + "
                                <div class=\"col-sm-7\">" + "
                                    <div class=\"input-group\">" + "
                                        <input class=\"form-control text-right\" data-bind=\"value: order.tradeTotal\" type=\"text\" readonly=\"readonly\" value=\"" + sum + "\">" + "
                                        <span class=\"input-group-addon\">" + ask  + "</span>" + "
                                    </div>" + "
                                </div>" + "
                            </div>" + "
                        </form>" + "
                    </div>" + "

                    <div data-bind=\"html: order.orderModalAlert\"></div>" + "
                    <div class=\"bs-callout bs-callout-warning\">" + "
                        <h4>Disclaimer</h4>" + "
                        <p>Please verify this order before confirming. All orders are final once submitted and we will be unable to issue you a refund.</p>" + "
                    </div>" + "
                </div>"
      buttons:
        cancel:
          label: "Cancel"
          className: "btn-primary"
        main:
          label: "Confirm"
          className: "btn-primary"
          callback: (result) ->
            if(result)
              $("#new_order_ask").trigger "submit"
              return


