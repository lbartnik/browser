# --- Browser ----------------------------------------------------------
Browser = (element) ->
  options    = { shiny: false, knitr: false }
  size       = { width: 800, height: 600 }
  container  = null
  view       = null
  model      = null
  controller = null

  initialize = () ->
    log.debug("")
    options.shiny = (typeof HTMLWidgets != 'undefined' && HTMLWidgets.shinyMode)
    element = $(element)
    container = $("<div>", {class: "main-container"}).appendTo(element)

  browser = () ->

  browser.setData = (raw) ->
    log.debug("")
    model = DataSet(raw)
    view  = TextTreeView(container, model)
    controller = KeyboardController(view)
    view.refresh()

  browser.setSize = (width, height) ->
    size = { width: width, height: height }
  
  browser.setOption = (name, value) ->
    # TODO set option

  initialize()
  return browser

# --- exports ----------------------------------------------------------

window.Browser = Browser
