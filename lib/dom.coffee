module.exports = load: ({sections}) -> (->

  @$grid = sections.$grid
  @$rows = @$grid.find(".row")
  @$cols = @$grid.find(".col")

  this
).apply {}
