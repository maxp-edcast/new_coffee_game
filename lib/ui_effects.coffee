module.exports = (->

  @begin = ({DOM, Masonry, GameFlow}) =>

    @DOM = DOM
    @Masonry = Masonry
    @GameFlow = GameFlow

    # @configure_welcome()
    # @configure_char_select()
    # @configure_grid()

# =========================================

  @configure_welcome = () =>
    @route_button @DOM.$start_btn, =>
      @GameFlow.choose_character()

  @configure_grid = () =>
    @add_col_listeners(@DOM)

  @configure_char_select = () =>
    # @add_masonry(Masonry, DOM)
    @add_char_opt_listeners(@DOM)

# =========================================

  @route_button = ($btn, fn) =>
    $btn.on 'click', fn

  @add_char_opt_listeners = () =>
    {$char_opts} = @DOM
    $char_opts.each @add_hover_listeners

  @add_col_listeners = () =>
    {$cols} = @DOM
    $cols.each @add_hover_listeners

  @add_hover_listeners = (idx, el) =>
    $el = $ el
    $el.on "mouseenter", (e) =>
      $(e.currentTarget).addClass "hovered"
    $el.on "mouseleave", (e) =>
      $(e.currentTarget).removeClass "hovered"

  @add_masonry = () =>
    {$char_select} = @DOM
    # NEED TO DEBUG THIS
    new Masonry $char_select[0],
      itemSelector: ".char-opt"
      columnWidth: 200

  this
).apply {}