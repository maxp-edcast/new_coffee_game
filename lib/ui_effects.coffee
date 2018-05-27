module.exports = (->

  @begin = ({DOM, Masonry, GameFlow, State}) =>
    @DOM = DOM
    @Masonry = Masonry
    @GameFlow = GameFlow
    @State = State

    @configure_global_listeners()

# =========================================

  @configure_global_listeners = =>
    @add_restart_handler(@DOM.$restart_btn)

  @configure_welcome = () =>
    @route_button @DOM.$start_btn, =>
      @GameFlow.choose_character()

  @configure_grid = () =>
    @add_col_listeners()
    @add_game_state()

  @configure_char_select = () =>
    # @add_masonry()
    @add_char_opt_listeners()

# =========================================

  @add_restart_handler = ($btn) =>
    $btn.on "click", @restart

  @restart = =>
    @GameFlow.welcome()

  @add_game_state = =>
    name = @State.char_name
    if name
      @DOM.$char_name.text(name)
    else
      @restart()

  @route_button = ($btn, fn) =>
    $btn.on 'click', fn

  @add_char_opt_listeners = () =>
    {$char_opts} = @DOM
    $char_opts.each @add_hover_listeners
    $char_opts.each @add_char_opt_click_listeners

  @add_col_listeners = () =>
    {$cols} = @DOM
    $cols.each @add_hover_listeners

  @add_char_opt_click_listeners = (idx, el) =>
    $el = $ el
    $el.on "click", (e) =>
      $char_opt = $ e.currentTarget
      $char_name = $char_opt.find(".char-name")
      @GameFlow.set_character($char_name.text())
      @GameFlow.start_game()

  @add_hover_listeners = (idx, el) =>
    $el = $ el
    $el.on "mouseenter", (e) =>
      $(e.currentTarget).addClass "hovered"
    $el.on "mouseleave", (e) =>
      $(e.currentTarget).removeClass "hovered"

  @add_masonry = () =>
    # NEED TO DEBUG THIS
    {$char_select} = @DOM
    new Masonry $char_select[0],
      itemSelector: ".char-opt"
      columnWidth: 200

  this
).apply {}