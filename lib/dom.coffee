module.exports = load: () -> (->

  @$body = $ "body"
  @$head = $ "head"

  @$game_container = @$body.find("#game-container")

  @$restart_btn = $ "#restart"

  @$welcome = $ require "html-loader!../views/welcome.slim"
  @$start_btn = @$welcome.find("#start")

  @$grid = $ require "html-loader!../views/grid.slim"
  @$rows = @$grid.find(".row")
  @$cols = @$grid.find(".col")
  @$char_name = @$grid.find(".char-name")
  @$level_name = @$grid.find(".level-name")

  @$char_select = $ require "html-loader!../views/char_select.slim"
  @$char_opts = @$char_select.find(".char-opt")

  @$level_select = $ require "html-loader!../views/level_select.slim"
  @$level_opts = @$level_select.find(".level-opt")

  this
).apply {}
