module.exports = ->

# =========================================

  @begin = ({DOM, ui_effects, State}) =>
    @State = State
    @ui_effects = ui_effects
    @DOM = DOM
    @welcome()

  @welcome = =>
    @DOM.$body.empty()
    @DOM.$body.append @DOM.$welcome
    @ui_effects.configure_welcome()

  @choose_character = =>
    @DOM.$body.empty()
    @DOM.$body.append @DOM.$char_select
    @ui_effects.configure_char_select()

  @start_game = =>
    @DOM.$body.empty()
    @DOM.$body.append @DOM.$grid
    @ui_effects.configure_grid()

# =========================================

  @set_character = (name) =>
    @State.char_name = name

  this
.apply {}