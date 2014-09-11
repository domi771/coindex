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
#  $("#new_order_bid").submit ->
#    $.msgbox "
#<div class=\"modal-header\">
#<h4 class=\"modal-title\" id=\"label_ConfirmOrder\" data-bind=\"text: order.orderModalTitle\">Confirm Buy Order</h4>
#                </div>
#                <div class=\"modal-body\">
#                    <div class=\"row\" style=\"margin-bottom:10px\">
#                        <div class=\"col-sm-4\"><h4 style=\"font-weight:bold\">Type:</h4></div>
#                        <div class=\"col-sm-8\"><h4 data-bind=\"text:order.tradeType\">Limit Buy</h4></div>
#                        <div class=\"col-sm-4\"><h4 style=\"font-weight:bold\">Market:</h4></div>
#                        <div class=\"col-sm-8\"><h4>BTC-RAW</h4></div>
#                    </div>
#<div class=\"row\" style=\"margin-bottom:10px;\">
#<form role=\"form\" class=\"form-horizontal\" accept-charset=\"UTF-8\" action=\"/markets/ltcbtc/order_bids\" class=\"new_order_bid\" data-remote=\"true\" id=\"new_order_bid\" method=\"post\"> 
#<div class=\"form-group\" style=\"margin-bottom:10px; text-align: right;\"> 
#<h5 class=\"col-sm-6\"> Quantity: </h5> 
#<div class=\"col-sm-16\"> <div class=\"input-group\"> <input class=\"form-control text-right\" data-bind=\"value: order.tradeQuantity\" type=\"text\" readonly=\"readonly\" value=\"0\"> <span class=\"input-group-addon\">RAW</span> </div> </div> </div> 
#<div class=\"form-group\" style=\"margin-bottom:10px; text-align: right;\"> 
#<h5 class=\"col-sm-6\"> Price: </h5> 
#<div class=\"col-sm-16\"> <div class=\"input-group\"> <input class=\"form-control text-right\" data-bind=\"value: order.tradePrice\" type=\"text\" readonly=\"readonly\" value=\"0\"> <span class=\"input-group-addon\">BTC</span> </div> </div> </div> 
#<div class=\"form-group\" style=\"margin-bottom:10px; text-align: right;\"> 
#<h5 class=\"col-sm-6\"> Subtotal: </h5> 
#<div class=\"col-sm-16\"> <div class=\"input-group\"> <input class=\"form-control text-right\" data-bind=\"value: order.tradeSubTotal\" type=\"text\" readonly=\"readonly\" value=\"0\"> <span class=\"input-group-addon\">BTC</span> </div> </div> </div> 
#<div class=\"form-group\" style=\"margin-bottom:10px; text-align: right;\"> 
#<h5 class=\"col-sm-6\"> Commission: </h5> 
#<div class=\"col-sm-16\"> <div class=\"input-group\"> <input class=\"form-control text-right\" data-bind=\"value: order.tradeCommission\" type=\"text\" readonly=\"readonly\" value=\"0\"> <span class=\"input-group-addon\">BTC</span> </div> </div> </div> 
#<div class=\"form-group\" style=\"margin-bottom:10px; text-align: right;\"> 
#<h5 class=\"col-sm-6\"> Total: </h5> 
#<div class=\"col-sm-16\"> <div class=\"input-group\"> <input class=\"form-control text-right\" data-bind=\"value: order.tradeTotal\" type=\"text\" readonly=\"readonly\" value=\"0\"> <span class=\"input-group-addon\">BTC</span> </div> </div> </div> 
#</form>
#
#                    <div style=\"text-align: left; margin-top: 40px;\">
#                        <h4>Disclaimer</h4>
#                        <p>Please verify this order before confirming. All orders are final once submitted and we will be unable to issue you a refund.</$
#                    </div>
#                </div>
# </div>
#
#
#",
#
#     form: {
#          active: true,
#          method: 'post',
#          action: '/markets/ltcbtc/order_bids'
#        },
#     type: 'confirm',
#      buttons: [
#        {
#          type: "submit"
#          value: "Confirm"
#        }
#        {
#          type: "cancel"
#          value: "Cancel"
#        }
#      ]
#
#    ,(buttonPressed) ->
#      
#      # do things
#      $("new_order_bid").send()  if buttonPressed
#      return
#
#    false
#
#  return

