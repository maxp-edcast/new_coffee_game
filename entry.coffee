
window.$ = require 'jquery'

require './style.sass'

ui_effects = require './lib/ui_effects.coffee'

sections =
  $grid: $ require "html-loader!./views/grid.slim"

$ ->

  $body = $ "body"
  $head = $ "head"

  $head.append $("<script>",
    type: "text/javacript",
    src: "./vendor/RPGUI/dist/rpgui.js"
  )
  $head.append $("<link>",
    type: "text/css",
    rel: "stylesheet",
    href: "./vendor/RPGUI/dist/rpgui.css"
  )

  DOM = require("./lib/dom.coffee").load({sections})


  $body.append sections.$grid

  ui_effects.begin({DOM})