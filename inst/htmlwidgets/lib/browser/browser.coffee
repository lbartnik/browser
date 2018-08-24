# --- Browser ----------------------------------------------------------
Browser = (element) ->
  options   = { shiny: false, knitr: false }
  size      = { width: 800, height: 600 }
  container = null
  view      = null
  model     = null

  initialize = () ->
    options.shiny = (typeof HTMLWidgets != 'undefined' && HTMLWidgets.shinyMode)
    element = $(element)
    container = $("<div>", {class: "main-container"}).appendTo(element)

  browser = () ->

  browser.setData = (raw) ->
    model = DataSet(raw)
    view  = TextTreeView(container, model)
    view.refresh()

  browser.setSize = (width, height) ->
    size = { width: width, height: height }

  initialize()
  return browser

# --- exports ----------------------------------------------------------

window.Browser = Browser
