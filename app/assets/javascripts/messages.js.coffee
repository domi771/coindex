update = ->
  $.get '/messages.json', null, (data, status, jqXHR) ->
    msgsSorted = _.sortBy data, (message) ->
      new Date(message.created_at).getTime() # get messages sorted by creation time ascending

    # refreshing messages list
    $('#chat').empty()
    for m in msgsSorted
      d = moment(m.created_at)
      $('#chat').append('<li>' +
      '<span class="created_at">' + d.format('HH:mm') + '</span>' +
      m.content +
      '</li>')

    $("#chat").mouseover ->
      $("#chat").stop()
      return

    height = 0
    $("#chat li").each (i, value) ->
      height += parseInt($(this).height())
      return

    height += ""
    $("#chat").animate scrollTop: height

    setTimeout update, 750 # polling at least every 750 ms but don't overlap between requests

update()

