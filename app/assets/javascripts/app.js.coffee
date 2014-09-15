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
    market = ask + "/" + bid
    price = $("#order_bid_price").val()
    volume = $("#order_bid_origin_volume").val()
    sum = $("#order_bid_total").val()
    price = parseFloat(price).toFixed(8)
    volume = parseFloat(volume).toFixed(8)
    sum_without_fee = (sum / 1.0025).toFixed(8)
    fee = sum - sum_without_fee
    fee = parseFloat(fee).toFixed(8)

    bootbox.dialog
      title: "#{gon.i18n.place_order.confirm_buy_title}"
      message:      "<div class=\"row\" style=\"margin-bottom:10px\">" + "
                        <div class=\"col-sm-offset-1 col-sm-2\"><h4 style=\"font-weight:bold\">#{gon.i18n.place_order.type}:</h4></div>" + "
                        <div class=\"col-sm-3\"><h4 data-bind=\"text:order.tradeType\">#{gon.i18n.place_order.type_buy}</h4></div>" + "
                        <div class=\"col-sm-2\"><h4 style=\"font-weight:bold\">#{gon.i18n.place_order.market}:</h4></div>" + "
                        <div class=\"col-sm-3\"><h4>" + market + "</h4></div>" + "
                    </div>" + "
                    <div id=\"form-container\">" + "
                        <form role=\"form\" class=\"form-horizontal\">" + "
                            <div class=\"form-group\" style=\"margin-bottom:10px\">" + "
                                <h5 class=\"col-sm-offset-1 col-sm-3\">" + "
                                     #{gon.i18n.place_order.volume}:" + "
                                </h5>" + "
                                <div class=\"col-sm-7\">" + "
                                    <div class=\"input-group\">" + "
                                        <input class=\"form-control text-right\" type=\"text\" readonly=\"readonly\" value=\"" + volume + "\">" + "
                                        <span class=\"input-group-addon\" style=\"min-width: 60px; text-align: center; font-size: 10px; font-weight: normal;\">" + ask  + "</span>" + "
                                    </div>" + "
                                </div>" + "
                            </div>" + "
                            <div class=\"form-group\" style=\"margin-bottom:10px\">" + "
                                <h5 class=\"col-sm-offset-1 col-sm-3\">" + "
                                     #{gon.i18n.place_order.price}:" + "
                                </h5>" + "
                                <div class=\"col-sm-7\">" + "
                                    <div class=\"input-group\">" + "
                                        <input class=\"form-control text-right\" type=\"text\" readonly=\"readonly\" value=\"" +price + "\">" + "
                                        <span class=\"input-group-addon\" style=\"min-width: 60px; text-align: center; font-size: 10px; font-weight: normal;\">" + bid  + "</span>" + "
                                    </div>" + "
                                </div>" + "
                            </div>" + "
                            <div class=\"form-group\" style=\"margin-bottom:10px\">" + "
                                <h5 class=\"col-sm-offset-1 col-sm-3\">" + "
                                     #{gon.i18n.place_order.subtotal}:" + "
                                </h5>" + "
                                <div class=\"col-sm-7\">" + "
                                    <div class=\"input-group\">" + "
                                        <input class=\"form-control text-right\" data-bind=\"value: order.tradeSubTotal\" type=\"text\" readonly=\"readonly\" value=\"" + sum_without_fee + "\">" + "
                                        <span class=\"input-group-addon\" style=\"min-width: 60px; text-align: center; font-size: 10px; font-weight: normal;\">" + ask  + "</span>" + "
                                    </div>" + "
                                </div>" + "
                            </div>" + "
                            <div class=\"form-group\" style=\"margin-bottom:10px\">" + "
                                <h5 class=\"col-sm-offset-1 col-sm-3\">" + "
                                     #{gon.i18n.place_order.fee}:" + "
                                </h5>" + "
                                <div class=\"col-sm-7\">" + "
                                    <div class=\"input-group\">" + "
                                        <input class=\"form-control text-right\" data-bind=\"value: order.tradeCommission\" type=\"text\" readonly=\"readonly\" value=\"" + fee + "\">" + "
                                        <span class=\"input-group-addon\" style=\"min-width: 60px; text-align: center; font-size: 10px; font-weight: normal;\">" + ask  + "</span>" + "
                                    </div>" + "
                                </div>" + "
                            </div>" + "
                            <div class=\"form-group\" style=\"margin-bottom:10px\">" + "
                                <h5 class=\"col-sm-offset-1 col-sm-3\">" + "
                                     #{gon.i18n.place_order.confirm_total}:" + "
                                </h5>" + "
                                <div class=\"col-sm-7\">" + "
                                    <div class=\"input-group\">" + "
                                        <input class=\"form-control text-right\" data-bind=\"value: order.tradeTotal\" type=\"text\" readonly=\"readonly\" value=\"" + sum + "\">" + "
                                        <span class=\"input-group-addon\" style=\"min-width: 60px; text-align: center; font-size: 10px; font-weight: normal;\">" + ask  + "</span>" + "
                                    </div>" + "
                                </div>" + "
                            </div>" + "
                        </form>" + "
                    </div>" + "
                    <div style=\"margin-top: 30px;\">" + "
                        <h5> #{gon.i18n.place_order.disclaimer_header}</h5>" + "
                        <p>#{gon.i18n.place_order.disclaimer_body}</p>" + "
                    </div>" + "
                </div>"
      buttons:
        cancel:
          label: "#{gon.i18n.place_order.cancel}"
          className: "btn-info"
        main:
          label: "#{gon.i18n.place_order.confirm}"
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
    market = ask + "/" + bid
    price = $("#order_ask_price").val()
    volume = $("#order_ask_origin_volume").val()
    sum = $("#order_ask_total").val()
    price = parseFloat(price).toFixed(8)
    volume = parseFloat(volume).toFixed(8)
    sum_without_fee = (sum / 0.9975).toFixed(8)
    fee = sum_without_fee - sum
    fee = parseFloat(fee).toFixed(8)

    bootbox.dialog
      title: "#{gon.i18n.place_order.confirm_sell_title}"
      message:      "<div class=\"row\" style=\"margin-bottom:10px\">" + "
                        <div class=\"col-sm-offset-1 col-sm-2\"><h4 style=\"font-weight:bold\">#{gon.i18n.place_order.type}:</h4></div>" + "
                        <div class=\"col-sm-3\"><h4 data-bind=\"text:order.tradeType\">#{gon.i18n.place_order.type_sell}</h4></div>" + "
                        <div class=\"col-sm-2\"><h4 style=\"font-weight:bold\">#{gon.i18n.place_order.market}:</h4></div>" + "
                        <div class=\"col-sm-3\"><h4>" + market + "</h4></div>" + "
                    </div>" + "
                    <div id=\"form-container\">" + "
                        <form role=\"form\" class=\"form-horizontal\">" + "
                            <div class=\"form-group\" style=\"margin-bottom:10px\">" + "
                                <h5 class=\"col-sm-offset-1 col-sm-3\">" + "
                                     #{gon.i18n.place_order.volume}:" + "
                                </h5>" + "
                                <div class=\"col-sm-7\">" + "
                                    <div class=\"input-group\">" + "
                                        <input class=\"form-control text-right\" type=\"text\" readonly=\"readonly\" value=\"" + volume + "\">" + "
                                        <span class=\"input-group-addon\" style=\"min-width: 60px; text-align: center; font-size: 10px; font-weight: normal;\">" + ask  + "</span>" + "
                                    </div>" + "
                                </div>" + "
                            </div>" + "
                            <div class=\"form-group\" style=\"margin-bottom:10px\">" + "
                                <h5 class=\"col-sm-offset-1 col-sm-3\">" + "
                                     #{gon.i18n.place_order.price}:" + "
                                </h5>" + "
                                <div class=\"col-sm-7\">" + "
                                    <div class=\"input-group\">" + "
                                        <input class=\"form-control text-right\" type=\"text\" readonly=\"readonly\" value=\"" +price + "\">" + "
                                        <span class=\"input-group-addon\" style=\"min-width: 60px; text-align: center; font-size: 10px; font-weight: normal;\">" + bid  + "</span>" + "
                                    </div>" + "
                                </div>" + "
                            </div>" + "
                            <div class=\"form-group\" style=\"margin-bottom:10px\">" + "
                                <h5 class=\"col-sm-offset-1 col-sm-3\">" + "
                                     #{gon.i18n.place_order.subtotal}:" + "
                                </h5>" + "
                                <div class=\"col-sm-7\">" + "
                                    <div class=\"input-group\">" + "
                                        <input class=\"form-control text-right\" data-bind=\"value: order.tradeSubTotal\" type=\"text\" readonly=\"readonly\" value=\"" + sum_without_fee + "\">" + "
                                        <span class=\"input-group-addon\" style=\"min-width: 60px; text-align: center; font-size: 10px; font-weight: normal;\">" + ask  + "</span>" + "
                                    </div>" + "
                                </div>" + "
                            </div>" + "
                            <div class=\"form-group\" style=\"margin-bottom:10px\">" + "
                                <h5 class=\"col-sm-offset-1 col-sm-3\">" + "
                                     #{gon.i18n.place_order.fee}:" + "
                                </h5>" + "
                                <div class=\"col-sm-7\">" + "
                                    <div class=\"input-group\">" + "
                                        <input class=\"form-control text-right\" data-bind=\"value: order.tradeCommission\" type=\"text\" readonly=\"readonly\" value=\"" + fee + "\">" + "
                                        <span class=\"input-group-addon\" style=\"min-width: 60px; text-align: center; font-size: 10px; font-weight: normal;\">" + ask  + "</span>" + "
                                    </div>" + "
                                </div>" + "
                            </div>" + "
                            <div class=\"form-group\" style=\"margin-bottom:10px\">" + "
                                <h5 class=\"col-sm-offset-1 col-sm-3\">" + "
                                     #{gon.i18n.place_order.confirm_total}:" + "
                                </h5>" + "
                                <div class=\"col-sm-7\">" + "
                                    <div class=\"input-group\">" + "
                                        <input class=\"form-control text-right\" data-bind=\"value: order.tradeTotal\" type=\"text\" readonly=\"readonly\" value=\"" + sum + "\">" + "
                                        <span class=\"input-group-addon\" style=\"min-width: 60px; text-align: center; font-size: 10px; font-weight: normal;\">" + ask  + "</span>" + "
                                    </div>" + "
                                </div>" + "
                            </div>" + "
                        </form>" + "
                    </div>" + "
                    <div style=\"margin-top: 30px;\">" + "
                        <h5> #{gon.i18n.place_order.disclaimer_header}</h5>" + "
                        <p>#{gon.i18n.place_order.disclaimer_body}</p>" + "
                    </div>" + "
                </div>"
      buttons:
        cancel:
          label: "#{gon.i18n.place_order.cancel}"
          className: "btn-info"
        main:
          label: "#{gon.i18n.place_order.confirm}"
          className: "btn-primary"
          callback: (result) ->
            if(result)
              $("#new_order_ask").trigger "submit"
              return


