@MarketChartUI = flight.component ->

  @drawChart = ->
    @$node.highcharts "StockChart",
      credits:
        enabled: false

      tooltip:
        valueDecimals: gon.market.bid.fixed

      chart:
        height: 360
        marginRight: 30
        zoomType: "x"

        events:
          load: ->
            series = @series
            update = ->
              $.getJSON "/api/v2/k.json?market=#{gon.market.id}&limit=1000000&period=60", (data) ->

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

            update()
            setInterval ->
              update
            , 1

      plotOptions:
        candlestick:
          color: '#d45252'
          upColor: '#39b576'
        column:
          color: '#227da2'
          groupPadding: 0

      scrollbar:
        enabled: false

      navigator:
        top: 300
        enabled: false

      rangeSelector:
        inputEnabled: false
        selected: 3
        buttons: [
          {
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
          opposite: false
          labels:
            align: "right"
            x: -8
          title:
            text: gon.i18n.chart_price
          height: "80%"
          lineWidth: 1
        }
        {
          opposite: false
          labels:
            align: "right"
            x: -8
          title:
            text: gon.i18n.chart_volume
          top: "82%"
          height: "18%"
          offset: 0
          lineWidth: 1
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

