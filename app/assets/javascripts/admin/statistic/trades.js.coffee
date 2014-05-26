$ ->
  $(".trades-chart").highcharts
    title:
      text: "累计成交总笔数"
      x: -20
    subtitle:
      text: ""
      x: -20

    xAxis:
      categories: $.map(gon.stat_count, (key, value)-> value )

    yAxis:
      title:
        text: ""

      plotLines: [
        value: 0
        width: 1
      ]

    tooltip:
      valueSuffix: ""

    legend:
      layout: "vertical"
      align: "right"
      verticalAlign: "middle"
      borderWidth: 0

    series: [
      name: "累计成交总笔数"
      data: $.map(gon.stat_count, (key, value) -> key)
    ]

  $(".trades-chart-1").highcharts
    title:
      text: "累计成交coin总额"
      x: -20
    subtitle:
      text: ""
      x: -20

    xAxis:
      categories: $.map(gon.stat_volume_count, (key, value)-> value )

    yAxis:
      title:
        text: ""

      plotLines: [
        value: 0
        width: 1
      ]

    tooltip:
      valueSuffix: ""

    legend:
      layout: "vertical"
      align: "right"
      verticalAlign: "middle"
      borderWidth: 0

    series: [
      name: "累计成交coin总额"
      color: "#8bbc21"
      data: $.map(gon.stat_volume_count, (key, value) -> parseFloat(key))
    ]

  $(".trades-chart-2").highcharts
    title:
      text: "累计成交cny总额"
      x: -20
    subtitle:
      text: ""
      x: -20

    xAxis:
      categories: $.map(gon.stat_trade_members_count, (key, value)-> value )

    yAxis:
      title:
        text: ""

      plotLines: [
        value: 0
        width: 1
      ]

    tooltip:
      valueSuffix: ""

    legend:
      layout: "vertical"
      align: "right"
      verticalAlign: "middle"
      borderWidth: 0

    series: [
      name: "累计成交cny总额"
      color: "#910000"
      data: $.map(gon.stat_trade_members_count, (key, value) -> parseFloat(key))
    ]