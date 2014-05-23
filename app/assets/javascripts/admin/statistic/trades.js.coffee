$ ->
  $(".trades-chart").highcharts
    title:
      text: "Count"
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
      name: "Count"
      data: $.map(gon.stat_count, (key, value) -> key)
    ]

  $(".trades-chart-1").highcharts
    title:
      text: "Volume Count"
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
      name: "Volume Count"
      color: "#8bbc21"
      data: $.map(gon.stat_volume_count, (key, value) -> parseFloat(key))
    ]

  $(".trades-chart-2").highcharts
    title:
      text: "Trade Members Count"
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
      name: "Volume Count"
      color: "#910000"
      data: $.map(gon.stat_trade_members_count, (key, value) -> parseFloat(key))
    ]