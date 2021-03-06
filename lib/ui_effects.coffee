
# =========================================
# THIS FILE RELATES TO UI BEHAVIOR IN ANY FORM
# =========================================

module.exports = (->

  @begin = (deps) =>
    Object.assign this, deps

    @configure_main_menu_listeners()

# =========================================
# DISPATCHERS
# =========================================

  @configure_main_menu_listeners = =>
    @add_main_menu_handler(@DOM.$main_menu_btn)
    @add_wipe_data_handler(@DOM.$wipe_data_btn)
    @add_export_game_state_handler(@DOM.$export_game_state_btn)

  @configure_welcome = () =>
    @route_button @DOM.$start_btn, =>
      @GameFlow.choose_character()

  @configure_grid = () =>
    @add_game_state()
    @add_col_hover_listeners()
    @add_col_click_listeners()
    # @add_keyboard_controls()

  @configure_char_select = () =>
    # @add_masonry()
    @add_char_opt_listeners()

  @configure_level_select = () =>
    # @add_masonry()
    @add_level_opt_listeners()

# =========================================
# HELPERS
# =========================================

  @ms_per_move = 150

  @add_keyboard_controls = =>
    @DOM.$body.on 'keydown', (e) =>
      e.preventDefault()
      direction = switch e.keyCode
        when 37 then "left"
        when 38 then "up"
        when 39 then "right"
        when 40 then "down"
      if direction && @State.player_coords
        @GridActions.move(@State.player_coords, direction)

  @add_col_hover_listeners = =>
    @DOM.$cols.on "mouseenter", @col_hovered

  @col_hovered = (e) =>
    $el = $ e.currentTarget
    [row_idx, col_idx] = ["row-idx", "col-idx"].map (key) => $el.data(key)
    col_attrs = @State.grid_code_matrix[row_idx][col_idx]
    # console.log col_attrs

  @add_col_click_listeners = =>
    @DOM.$cols.on "click", @col_clicked

  @col_clicked = (e) =>
    $el = $ e.currentTarget
    target_coords = ["row-idx", "col-idx"].map (key) => $el.data(key)
    start_key = @State.player_coords.join(",")
    end_key = target_coords.join(",")
    path = @State.pathfinder_graph.path start_key, end_key
    if path
      @move_on_path(path)
    else
      @cant_move_to_col(target_coords)

  @move_on_path = (path, ms_per_move) =>
    ms_per_move ||= @ms_per_move
    path.shift() # the first item in the path is the origin.
    @illustrate_path(path)
    interval = setInterval =>
      target = path.shift()
      unless target
        clearInterval(interval)
        return
      [next_row_idx, next_col_idx] = target.split(",").map (idx) =>
        parseInt idx
      [player_row_idx, player_col_idx] = @State.player_coords
      row_diff = next_row_idx - player_row_idx
      col_diff = next_col_idx - player_col_idx
      @GridActions.move(
        @State.player_coords,
        vector: [row_diff, col_diff]
      )
    , ms_per_move

  @cant_move_to_col = (coords) =>

  @illustrate_path = (path) =>

  @add_main_menu_handler = ($btn) =>
    $btn.on "click", @main_menu

  @add_wipe_data_handler = ($btn) =>
    $btn.on "click", @wipe_data

  @add_export_game_state_handler = ($btn) =>
    $btn.on "click", @export_game_state

  @wipe_data = =>
    @GameFlow.clear_localstorage()
    alert("data wiped")
    @main_menu()

  @show_error = (msg) =>
    @DOM.$error.text msg

  @export_game_state = =>
    @DOM.$body.empty()
    @DOM.$body.append(JSON.stringify @State)

  @main_menu = =>
    @GameFlow.welcome()

  @add_game_state = =>
    @DOM.$char_name.text(@State.char_name)
    @DOM.$level_name.text(@State.level_name)
    @add_current_level_to_grid()

  @add_current_level_to_grid = =>
    @GameFlow.apply_level_data(@State.level_data)
    @State.grid_code_matrix.forEach (row, row_idx) =>
      row.forEach (col, col_idx) =>
        @set_icon(row_idx, col_idx, col.icon)

  @set_icon = (row_idx, col_idx, icon) =>
    $col = @DOM.grid_content_matrix[row_idx][col_idx]
    $col.empty()
    $col.append(icon)

  @route_button = ($btn, fn) =>
    $btn.on 'click', fn

  @add_char_opt_listeners = () =>
    {$char_opts} = @DOM
    $char_opts.each @add_char_opt_click_listeners

  @add_level_opt_listeners = () =>
    {$level_opts} = @DOM
    $level_opts.each @add_level_opt_click_listeners

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

  @add_masonry = () =>
    # NEED TO DEBUG THIS
    {$char_select} = @DOM
    new Masonry $char_select[0],
      itemSelector: ".char-opt"
      columnWidth: 200

  this
).apply {}