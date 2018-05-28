module.exports = (->

  @vectors = {
    up: [-1, 0]
    down: [1, 0]
    left: [0, -1]
    right: [0, 1]
  }

  @begin = (deps) =>
    Object.assign this, deps

  @move = ([row_idx, col_idx], direction) =>
    [row_vector, col_vector] = @vectors[direction]
    orig_row = @State.grid_code_matrix[row_idx]
    orig_col = orig_row[col_idx]
    next_row_idx = row_idx + row_vector
    next_col_idx = col_idx + col_vector
    next_row = @State.grid_code_matrix[next_row_idx]
    next_col = next_row[next_col_idx]

    moving_obj = @util.filter_hash orig_col, except: ['original_occupant']

    if orig_col.original_occupant
      orig_row[col_idx] = orig_col.original_occupant
    else
      orig_row[col_idx] = @GameFlow.default_ground_col()

    next_row[next_col_idx] = Object.assign {}, moving_obj, {
      original_occupant: Object.assign({}, next_row[next_col_idx])
    }

    debugger

    @ui_effects.set_icon row_idx, col_idx, orig_row[col_idx].icon
    @ui_effects.set_icon next_row_idx, next_col_idx, moving_obj.icon

  this
).apply {}