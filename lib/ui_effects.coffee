module.exports = (->

  @begin = ({DOM, Masonry, GameFlow, State}) =>
    @DOM = DOM
    @Masonry = Masonry
    @GameFlow = GameFlow
    @State = State

    @configure_main_menu_listeners()

# =========================================

  @configure_main_menu_listeners = =>
    @add_main_menu_handler(@DOM.$main_menu_btn)
    @add_wipe_data_handler(@DOM.$wipe_data_btn)

  @configure_welcome = () =>
    @route_button @DOM.$start_btn, =>
      @GameFlow.choose_character()

  @configure_grid = () =>
    @add_col_listeners()
    @add_game_state()

  @configure_char_select = () =>
    # @add_masonry()
    @add_char_opt_listeners()

  @configure_level_select = () =>
    # @add_masonry()
    @add_level_opt_listeners()

# =========================================

  @add_main_menu_handler = ($btn) =>
    $btn.on "click", @main_menu

  @add_wipe_data_handler = ($btn) =>
    $btn.on "click", @wipe_data

  @wipe_data = =>
    @GameFlow.clear_localstorage()
    @main_menu()

  @main_menu = =>
    @GameFlow.welcome()

  @add_game_state = =>
    @DOM.$char_name.text(@State.char_name)
    @DOM.$level_name.text(@State.level_name)
    @add_current_level_to_grid()

  @add_current_level_to_grid = =>
    level_data = @State.level_data
    level_data.map.split("\n").forEach (row, row_idx) =>
      row.split("").forEach (icon, col_idx) =>
        @DOM.grid_matrix[row_idx].eq(col_idx).text(icon)

  @route_button = ($btn, fn) =>
    $btn.on 'click', fn

  @add_char_opt_listeners = () =>
    {$char_opts} = @DOM
    $char_opts.each @add_hover_listeners
    $char_opts.each @add_char_opt_click_listeners


  @add_level_opt_listeners = () =>
    {$level_opts} = @DOM
    $level_opts.each @add_hover_listeners
    $level_opts.each @add_level_opt_click_listeners


  @add_col_listeners = () =>
    {$cols} = @DOM
    $cols.each @add_hover_listeners

  @add_level_opt_click_listeners = (idx, el) =>
    $el = $ el
    $el.on "click", (e) =>
      $level_opt = $ e.currentTarget
      $level_name = $level_opt.find(".level-name")
      @GameFlow.set_level($level_name.text())
      @GameFlow.start_game()

  @add_char_opt_click_listeners = (idx, el) =>
    $el = $ el
    $el.on "click", (e) =>
      $char_opt = $ e.currentTarget
      $char_name = $char_opt.find(".char-name")
      @GameFlow.set_character($char_name.text())
      @GameFlow.choose_level()

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