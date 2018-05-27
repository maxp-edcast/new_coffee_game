module.exports = (->

  context = require.context(
    "json-loader!yaml-loader!../content/levels",
    false,
    /\.yml$/
  )
  @levels = context.keys()
    .map(context)
    .reduce (memo, level_data) ->
      Object.assign {}, memo, level_data
    , {}

  this
).apply {}