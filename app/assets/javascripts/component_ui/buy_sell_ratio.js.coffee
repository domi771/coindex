@BuysellratioChartUI = flight.component ->

  Highcharts.setOptions colors: [
     "rgba(204,63,51,1.0)"
     "rgba(90,151,112,1.0)"
  ]

  @drawChart = ->
    @$node.highcharts "StockChart",
      credits:
        enabled: false

      chart:
        marginRight: 0
        zoomType: "x"
        height: 165

        events:
          load: ->
            series = @series
            update = ->
              #$.getJSON "http://www.bfxdata.com/json/sellBuyRatio24HourBTCUSD.json", (json) ->
              # $.getJSON "http://www.bfxdata.com/json/marketDepthBidsBTCUSD.json", (bidsJSON) ->

                #bid = [[0,0]]
                #ask = [[0,0]]

                #bid = [[478.88,5235.47],[480,5235.37],[480.04,4954.54]]
                #ask = [[509.9,2.22],[510,24.35],[510.69,24.57],[510.7,24.82]]

                series[0].setData ([parseFloat(i[0]), parseFloat(i[1])] for i in data.bids)
                series[1].setData ([parseFloat(i[0]), parseFloat(i[1])] for i in data.asks)
                console.info ([parseFloat(i[0]), parseFloat(i[1])] for i in data.bids)
                console.info ([parseFloat(i[0]), parseFloat(i[1])] for i in data.asks)
                console.info series[0]
                #series[0].setData bid
                #series[1].setData ask


            update()
            setInterval ->
              update
            , 10000

      navigator:
        enabled: false

      rangeSelector:
        inputEnabled: false
        enabled: false

      scrollbar:
        enabled: false
  
      exporting:
        enabled: false
      
      tooltip:
        pointFormat: "<b>{point.percentage:.1f}%</b>"

      plotOptions:
        pie:
          size: "165%"
          dataLabels:
            enabled: true
            distance: -30
            style:
              fontWeight: "bold"
              color: "white"
              textShadow: "0px 1px 2px black"

          animation: false
          startAngle: -90
          endAngle: 90
          center: [
            "50%"
            "95%"
          ]

      series: [
        type: "pie"
        name: "Buy / Sell Ratio"
        innerSize: "85%"
        # data: json
        data: [["Sell",0.46],["Buy",0.54]]
      ]

  @after 'initialize', ->
    @drawChart()

