
# =========================================

window.$ = require 'jquery'

require './style.sass'

Masonry = require 'masonry-layout'

ui_effects = require './lib/ui_effects.coffee'

GameFlow = require './lib/game_flow.coffee'

GraphemeSplitter = require 'grapheme-splitter'
grapheme_splitter = new GraphemeSplitter()

Pathfinder = require('node-dijkstra')

util = require './lib/util.coffee'

GridActions = require './lib/grid_actions.coffee'
window.State = {}

window.Config = require './config/config.coffee'

# =========================================

$ ->

  DOM = require("./lib/dom.coffee").load()
  window._DOM = DOM

  DOM.$head.append $("<script>",
    type: "text/javacript",
    src: "./vendor/RPGUI/dist/rpgui.js"
  )
  DOM.$head.append $("<link>",
    type: "text/css",
    rel: "stylesheet",
    href: "./vendor/RPGUI/dist/rpgui.css"
  )

# =========================================

  deps = {
    DOM, Masonry, GameFlow, State, ui_effects, Config, grapheme_splitter,
    GridActions, util, Pathfinder
  }

  ui_effects.begin(deps)
  GridActions.begin(deps)
  GameFlow.begin(deps)
