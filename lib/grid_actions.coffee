module.exports = (->

  @vectors = {
    up: [-1, 0]
    down: [1, 0]
    left: [0, -1]
    right: [0, 1]
  }

  @begin = (deps) =>
    Object.assign this, deps

  @seed_pathfinder = =>
    grid = @State.grid_code_matrix
    # see https://github.com/albertorestifo/node-dijkstra
    graph_hash = grid.reduce (memo, row, row_idx) =>
      row.forEach (col, col_idx) =>
        return unless ['walkable', 'agent'].some (attr) => col[attr]
        coords = [row_idx, col_idx]
        neighbors = @neighbors(coords)
        col_key = coords.join(",")
        links = neighbors.reduce (memo, [neighbor_coords, neighbor]) =>
          neighbor_key = neighbor_coords.join(",")
          weight = neighbor.walk_weight || 1
          memo[neighbor_key] = weight if neighbor.walkable
          memo
        , {}
        memo[col_key] = links
        # debugger if row_idx == 14 && col_idx == 15
      memo
    , {}
    @State.pathfinder_hash = graph_hash
    @State.pathfinder_graph = new @Pathfinder graph_hash

  @update_pathfinder_node = (changed_coords, {bidirectional=true}) =>

  @neighbors = ([row_idx, col_idx]) =>
    Object.values(@vectors).map ([row_vector, col_vector]) =>
      next_row_idx = row_idx + row_vector
      next_col_idx = col_idx + col_vector
      row = @State.grid_code_matrix[next_row_idx]
      col = if row then row[next_col_idx]
      [[next_row_idx, next_col_idx], col]
    .filter ([_coords, col]) => col

  @move = (orig_coords, {direction, vector}, conditional_fn) =>
    [row_idx, col_idx] = orig_coords
    conditional_fn ||= => true

    [row_vector, col_vector] = if direction
      @vectors[direction]
    else
      vector

    orig_row = @State.grid_code_matrix[row_idx]
    orig_col = orig_row[col_idx]
    next_row_idx = row_idx + row_vector
    next_col_idx = col_idx + col_vector
    next_row = @State.grid_code_matrix[next_row_idx]
    next_col = next_row[next_col_idx]

    next_coords = [next_row_idx, next_col_idx]

    return unless next_col
    return unless conditional_fn(orig_coords, next_coords, orig_col, next_col)

    moving_obj = @util.filter_hash orig_col, except: ['original_occupant']

    if orig_col.original_occupant
      orig_row[col_idx] = orig_col.original_occupant
    else
      orig_row[col_idx] = @GameFlow.default_ground_col()

    next_row[next_col_idx] = Object.assign {}, moving_obj, {
      original_occupant: Object.assign({}, next_row[next_col_idx])
    }

    @State.player_coords = next_coords

    @ui_effects.set_icon row_idx, col_idx, orig_row[col_idx].icon
    @ui_effects.set_icon next_row_idx, next_col_idx, moving_obj.icon

    [orig_coords, next_coords].forEach @update_pathfinder_node

  this
).apply {}