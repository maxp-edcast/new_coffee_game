
window.$ = require 'jquery'

require './style.sass'

ui_effects = require './lib/ui_effects.coffee'

sections =
  $grid: $ require "html-loader!./views/grid.slim"

$ ->

  DOM = require("./lib/dom.coffee").load({sections})

  $body = $ "body"

  $body.append sections.$grid

  ui_effects.begin({DOM})