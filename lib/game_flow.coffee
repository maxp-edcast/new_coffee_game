module.exports = ->

# =========================================

  @begin = ({DOM, ui_effects, State}) =>
    @State = State
    @ui_effects = ui_effects
    @DOM = DOM
    @route_url()

  @welcome = =>
    @DOM.$game_container.empty()
    @DOM.$game_container.append @DOM.$welcome
    @ui_effects.configure_welcome()
    @set_path ""

  @choose_character = =>
    @DOM.$game_container.empty()
    @DOM.$game_container.append @DOM.$char_select
    @ui_effects.configure_char_select()
    @set_path "choose_character"

  @start_game = =>
    @DOM.$game_container.empty()
    @DOM.$game_container.append @DOM.$grid
    @ui_effects.configure_grid()
    @set_path "game"

# =========================================

  @route_url = =>
    routes_table = {
      "#": @welcome,
      "#choose_character": @choose_character,
      "#game": @start_game
    }
    fn = routes_table[@get_path()]
    if fn then fn() else @welcome()

  @set_path = (path) =>
    # AVOID INFINITE LOOP!
    unless path == location.hash
      location.hash = path

  @get_path = =>
    location.hash

  @set_character = (name) =>
    @State.char_name = name

  this
.apply {}