# --- DataSet ----------------------------------------------------------

# Create a data set wrapper.
#
# The data set wrapper is handy for the following two reasons:
#   * JSON data received from R might require certain transformations
#   * wrapper acts as an abstraction layer and hides chages in how the
#     data is formatted and/or handled on either side (R and JS browser)
#
# @param raw JSON data received from R.
#
DataSet = (raw) ->

  dataset = () ->

  # Turns a list of elements into a tree.
  stratified = () ->
    stratify = d3.stratify()
      .id((d) -> d.id)
      .parentId (d) ->
        # JSON array for mulitple parents is simplified if there is only one parent
        return d.parents[0] if d.parents instanceof Array
        return d.parents
    stratify(raw)

  # Transforms the raw data into a tree of elements.
  augmentAsTree = () ->
    log.debug("traversing as tree")

    traverse = (node, parent) ->
      # TODO add DFS parentheses
      node.data.level = node.level
      if node.children
        traverse(child, node.data) for child in node.children
    strats = stratified()
    traverse(strats, {})

  # --- for each -------------------------------------------------------
  dataset.forEach = (fun) ->
    raw.forEach fun

  # --- initialize and return ------------------------------------------
  augmentAsTree()
  return dataset


# --- exports ----------------------------------------------------------

window.DataSet = DataSet
