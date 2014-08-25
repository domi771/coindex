@OrderbookChartUI = flight.component ->

  @drawChart = ->
    @$node.highcharts "Chart",
      credits:
        enabled: false

      chart:
        marginRight: 30
        zoomType: "x"
        height: 375

        events:
          load: ->
            series = @series
            $.getJSON "/api/v2/depth.json?market=#{gon.market.id}", (data) ->

              ask = []
              for i in data.asks
                if ask.length is 0
                  ask.push [parseFloat(i[0]), parseFloat(i[1])]
                else
                  last = ask[ask.length - 1]
                  ask.push [parseFloat(i[0]), parseFloat(i[1])+last[1]]

              bid = []
              for i in data.bids.reverse()
                if bid.length is 0
                  bid.push [parseFloat(i[0]), parseFloat(i[1])]
                else
                  last = bid[bid.length - 1]
                  bid.push [parseFloat(i[0]), parseFloat(i[1])+last[1]]

              series[0].setData bid.reverse()
              series[1].setData ask


            setInterval (->
              $.getJSON "/api/v2/depth.json?market=#{gon.market.id}", (data) ->

                ask = []
                for i in data.asks
                  if ask.length is 0
                    ask.push [parseFloat(i[0]), parseFloat(i[1])]
                  else
                    last = ask[ask.length - 1]
                    ask.push [parseFloat(i[0]), parseFloat(i[1])+last[1]]

                bid = []
                for i in data.bids.reverse()
                  if bid.length is 0
                    bid.push [parseFloat(i[0]), parseFloat(i[1])]
                  else
                    last = bid[bid.length - 1]
                    bid.push [parseFloat(i[0]), parseFloat(i[1])+last[1]]

                series[0].setData bid.reverse()
                series[1].setData ask

            ), 5000

      navigator:
        enabled: false

      rangeSelector:
        inputEnabled: false
        enabled: false

      scrollbar:
        enabled: false
  
      title:
        text: ""
        style:
          display: "none"

      xAxis:

        #labels:
          #formatter: ->
            #@value.toString().substring 0, 6
        #tickInterval: 250,
        gridLineWidth: 0
        #minorTickInterval: "auto"
        #minorTickColor: "#FEFEFE"
        #type: "categorized"
        title:
          enabled: true
          text: "Price BTCUSD"
          style:
            fontWeight: "normal"
            display: "none"

      yAxis:
          
        #tickInterval: 250,
        gridLineWidth: "0.5"
        #minorTickInterval: "auto"
        #minorTickColor: "#FEFEFE"
        title:
          enabled: true
          text: "Volume Sum"
          style:
            fontWeight: "normal"
            display: "none"

      legend:
        enabled: true
        align: "center"
        verticalAlign: "top"
        y: 10
        floating: true
        backgroundColor: "#FFFFFF"

      plotOptions:
        series:
          lineWidth: 1
          animation: false
          marker:
            enabled: false

      tooltip:
        crosshairs: [
          true
          true
        ]

        formatter: ->
          @x + " " +gon.market.bid.currency.toUpperCase() + "<br\><b>" + @series.name + ":" +@y
 
      series: [
         {
           name: "Bids"
           type: "area"
           #dataGrouping:
              #enabled: true
              #forced: true
           color: "rgba(204,63,51,1.0)"
           fillColor: "rgba(204,63,51,0.2)"
         }
         {
           name: "Asks"
           #dataGrouping:
              #enabled: true
              #forced: true
           type: "area"
           color: "rgba(90,151,112,1.0)"
           fillColor: "rgba(90,151,112,0.2)"
         }
       ]

  @after 'initialize', ->
    @drawChart()

  return
