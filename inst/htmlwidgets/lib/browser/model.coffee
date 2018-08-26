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
      .parentId((d) -> d.parents[0] if d.parents?.length)
    stratify(raw)

  # Transforms the raw data into a tree of elements.
  dataset.traverseAsTree = (fun, root) ->
    log.debug("traversing as tree")
    traverse = (fun, node, parent) ->
      fun(node.data, parent)
      if node.children
        traverse(fun, child, node.data) for child in node.children
    strats = stratified()
    console.log(strats)
    traverse(fun, strats, root)
    

  return dataset


# --- exports ----------------------------------------------------------

window.DataSet = DataSet
