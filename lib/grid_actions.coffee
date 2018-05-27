module.exports = (->

  @vectors = {
    up: [-1, 0]
    down: [1, 0]
    left: [0, -1]
    right: [0, 1]

  @begin = ({deps}) =>
    Object.assign this, deps

  @move = ([row_idx, col_idx], direction, check_fn) =>
    check_fn ||= => true
    [row_vector, col_vector] = @vectors[direction]
    orig_row = @Grid.grid_code_matrix[row_idx]
    orig_col = next_row[col_idx]
    next_row_idx = row_idx + row_vector
    next_col_idx = col_idx + col_vector
    next_row = @Grid.grid_code_matrix[next_row_idx]
    next_col = next_row[next_col_idx]
    if check_fn([row_idx, col_idx], [next_row_idx, next_col_idx], next_col)
      @ui_effects.set_icon next_row_idx, next_col_idx


  this
).apply {}