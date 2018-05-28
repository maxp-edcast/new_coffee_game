module.exports = (->

  @filter_hash = (hash, {only, except}) =>
    keys = Object.keys(hash)
    if only
      keys = keys.filter (key) => only.includes(key)
    if except
      keys = keys.filter (key) => !except.includes(key)
    keys.reduce (memo, key) =>
      memo[key] = hash[key]
      memo
    , {}

  this
).apply {}