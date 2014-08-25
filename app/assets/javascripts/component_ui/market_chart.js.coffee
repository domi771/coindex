@MarketChartUI = flight.component ->

  @drawChart = ->
    @$node.highcharts "StockChart",

      credits:
        enabled: false

      tooltip:
        valueDecimals: gon.market.bid.fixed

      chart:
        # height: 350
        marginRight: 30
        zoomType: "x"

      loading:
        hideDuration: 1000
        #showDuration: 1000

        events:
          load: ->
            series = @series
            $.getJSON "/api/v2/k.json?market=#{gon.market.id}&limit=1000000&period=1", (data) ->

                ohlc = []
                volume = []
                dataLength = data.length
                i = 0
                while i < dataLength
                    ohlc.push [
                        Number(data[i][0]) * 1000 # the date
                        data[i][1] # open
                        data[i][2] # high
                        data[i][3] # low
                        data[i][4] # close
                    ]
                    volume.push [
                        Number(data[i][0]) * 1000 # the date
                        data[i][5] # the volume
                    ]
                    i++

                series[0].setData ohlc
                series[1].setData volume
                document.getElementById("pricechart-loading").style.display = "none"
                document.getElementById("pricechart").style.height = "411px"
                document.getElementById("pricechart").style.display = "block"
 
            setInterval (->
              $.getJSON "/api/v2/k.json?market=#{gon.market.id}&limit=1000000&period=1", (data) ->

                ohlc = []
                volume = []
                dataLength = data.length
                i = 0
                while i < dataLength
                    ohlc.push [
                        Number(data[i][0]) * 1000 # the date
                        data[i][1] # open
                        data[i][2] # high
                        data[i][3] # low
                        data[i][4] # close
                    ]
                    volume.push [
                        Number(data[i][0]) * 1000 # the date
                        data[i][5] # the volume
                    ]
                    i++

                series[0].setData ohlc
                series[1].setData volume
                # alert ohlc
            ), 30000

      plotOptions:
        candlestick:
          # color: '#d45252'
          upColor: "rgba(90,151,112,1.0)"
          color: "rgba(204,63,51,1.0)"
          # upColor: '#39b576'
        column:
          color: '#227da2'
          groupPadding: 0

      scrollbar:
        enabled: false

      navigator:
        enabled: false

      rangeSelector:
        enabled: true
        inputEnabled: false
        selected: 2
        allButtonsEnabled: true
        buttons: [
          {
            type: 'hour'
            count: 1
            text: '1h'
          }, {
            type: 'hour'
            count: 6
            text: '6h'
          }, {
            type: 'hour'
            count: 12
            text: '12h'
          }, {
            type: 'day'
            count: 1
            text: '1d'
          }, {
            type: 'week'
            count: 1
            text: '1w'
          }, {
            type: 'month'
            count: 1
            text: '1m'
          }, {
            type: 'all'
            text: 'ALL'
          }
        ]

      yAxis: [
        {
          gridLineWidth: "0.5"
          opposite: false
          labels:
            align: "right"
            x: -8
          title:
            text: gon.i18n.chart_price
          height: "80%"
          lineWidth: "0.5"
        }
        {
          gridLineWidth: "0.5"
          opposite: false
          labels:
            align: "right"
            x: -8
          title:
            text: gon.i18n.chart_volume
          top: "82%"
          height: "18%"
          offset: 0
          lineWidth: "0.5"
        }
      ]

      series: [
        {
          type: "candlestick"
          name: gon.i18n.chart_price
          yAxis: 0
          tooltip:
             valueSuffix: ' ' + gon.market.bid.currency.toUpperCase()
          dataGrouping:
             enabled: true
             forced: true
             units: [
               [
                'minute'
                [1]
               ]
               [
                'minute'
                [10]
               ]
               [
                'minute'
                [15]
               ]
               [
                'hour'
                [1]
               ]
               [
                'hour'
                [6]
               ]
               [
                'day'
                [1]
               ]
             ]
        }
        {
          type: "column"
          animation: true
          name: gon.i18n.chart_volume
          yAxis: 1
          tooltip:
             valueDecimals: 4
             valueSuffix: ' ' + gon.market.ask.currency.toUpperCase()
          dataGrouping:
             enabled: true
             units: [
               [
                'minute'
                [1]
               ]
               [
                'minute'
                [10]
               ]
               [
                'minute'
                [15]
               ]
               [
                'hour'
                [1]
               ]
               [
                'hour'
                [6]
               ]
               [
                'day'
                [1]
               ]

             ]
        }
      ]

  @after 'initialize', ->
    @drawChart()

