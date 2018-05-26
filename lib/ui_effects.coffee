module.exports = (->

  @begin = ({DOM}) =>
    @add_col_listeners(DOM)

  @add_col_listeners = ({$cols}) =>
    $cols.each @add_mouseenter_listeners

  @add_mouseenter_listeners = (idx, el) =>
    $el = $ el
    $el.on "mouseenter", (e) =>
      $(e.currentTarget).addClass "hovered"
    $el.on "mouseleave", (e) =>
      $(e.currentTarget).removeClass "hovered"

  this
).apply {}