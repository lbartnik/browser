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

  dataset.asTree = () ->
    

  return dataset


# --- exports ----------------------------------------------------------

window.DataSet = DataSet
