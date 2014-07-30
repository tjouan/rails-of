#= require d3-3.4.11


class DistributionChart
  margin:
    top:    20
    right:  20
    bottom: 30
    left:   60

  constructor: (@selector, @dataset) ->
    @width  = $(selector)[0].offsetWidth - @margin.left - @margin.right
    @height = 200 - @margin.top - @margin.bottom
    @x      = d3.scale.linear()
                .range([0, @width])
                .domain([0, @dataset.length])
    @xAxis  = d3.svg.axis()
                .scale(@x)
                .orient('bottom')
    @y      = d3.scale.linear()
                .range([@height, 0])
                .domain([0, d3.max(@dataset)])
    @yAxis  = d3.svg.axis()
                .scale(@y)
                .orient('left')

  append: ->
    svg   = @appendSVG @selector
    rect  = @appendRect svg

    @appendXAxis svg
    @appendYAxis svg

  appendSVG: (selector) ->
    d3.select(selector)
      .append('svg')
      .attr('class', 'chart')
      .attr('width', @width + @margin.left + @margin.right)
      .attr('height', @height + @margin.top + @margin.bottom)
      .append('g')
      .attr('transform', "translate(#{@margin.left}, #{@margin.top})")

  appendRect: (selector) ->
    selector.selectAll('g')
      .data(@dataset)
      .enter()
      .append('rect')
      .attr('class', 'chart-bar')
      .attr('x', (d, i) => @x(i))
      .attr('y', (d) => @y(d))
      .attr('width', @barWidth() - 1)
      .attr('height', (d) => @height - @y(d))

  appendXAxis: (selector) ->
    selector.append('g')
      .attr('class', 'chart-x chart-axis')
      .attr('transform', "translate(0, #{@height})")
      .call(@xAxis)

  appendYAxis: (selector) ->
    selector.append('g')
      .attr('class', 'chart-y chart-axis')
      .call(@yAxis)

  barWidth: ->
    @width / @dataset.length


@?.DistributionChart = DistributionChart
