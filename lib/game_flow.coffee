module.exports = ->

# =========================================

  @begin = (deps) =>
    Object.assign this, deps

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
    unless ['char_name', 'level_name'].every (key) => @State[key]
      return @welcome()
    @DOM.$game_container.empty()
    @DOM.$game_container.append @DOM.$grid
    @ui_effects.configure_grid()
    @set_path "game"

# =========================================

  @default_ground_col = =>
    {
      icon: @State.level_data.ground,
      type: "ground"
    }

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

  @apply_level_data = (level_data) =>
    @State.grid_code_matrix = level_data.map.split("\n").map (row, row_idx) =>
      @grapheme_splitter.splitGraphemes(row).map (char, col_idx) =>
        obj = Object.assign { icon: char }, @State.level_data.atlas[char]
        console.log(obj.type)
        debugger unless obj.type
        if obj.type == "player"
          @State.player_coords = [row_idx, col_idx]
        obj
    @sync_localstorage()

  this
.apply {}







