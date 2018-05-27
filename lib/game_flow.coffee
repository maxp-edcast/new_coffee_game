module.exports = ->

# =========================================

  @begin = ({DOM, ui_effects, State, Config}) =>
    Object.assign this, {DOM, ui_effects, State, Config}

    @load_localstorage_data()
    @route_url()

  @welcome = =>
    @DOM.$game_container.empty()
    @DOM.$game_container.append @DOM.$welcome
    @ui_effects.configure_welcome()
    @set_path ""

  @choose_character = =>
    return @choose_level() if @State.char_name
    @DOM.$game_container.empty()
    @DOM.$game_container.append @DOM.$char_select
    @ui_effects.configure_char_select()
    @set_path "choose_character"

  @choose_level = =>
    return @welcome() unless @State.char_name
    return @start_game() if @State.level_name
    @DOM.$game_container.empty()
    @DOM.$game_container.append @DOM.$level_select
    @ui_effects.configure_level_select()
    @set_path "choose_level"

  @start_game = =>
    unless ['char_name', 'level_name', 'level_data'].every (key) => @State[key]
      return @welcome()
    @DOM.$game_container.empty()
    @DOM.$game_container.append @DOM.$grid
    @ui_effects.configure_grid()
    @set_path "game"

# =========================================

  @load_localstorage_data = =>
    Object.assign @State, JSON.parse localStorage.getItem "game_data"

  @clear_localstorage = =>
    localStorage.setItem "game_data", JSON.stringify {}
    @State = {}

  @sync_localstorage = =>
    localStorage.setItem "game_data", JSON.stringify @State

  @route_url = =>
    routes_table = {
      "#": @welcome,
      "#choose_character": @choose_character,
      "#choose_level": @choose_level,
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
    @sync_localstorage()

  @set_level = (name) =>
    @State.level_name = name
    @State.level_data = @Config.levels[name]
    @sync_localstorage()

  this
.apply {}