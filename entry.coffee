
window.$ = require 'jquery'

require './style.sass'

sections =
  $grid: $ require "html-loader!./views/grid.slim"

$ ->
  $body = $ "body"
  # debugger
  $body.append sections.$grid