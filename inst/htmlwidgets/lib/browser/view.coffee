# --- Browser ----------------------------------------------------------
Browser = (element) ->
  options  = { shiny: false, knitr: false }
  data     = null
  size     = { width: 800, height: 600 }

  browser = () ->

  browser.setData = (input) ->
    data = DataSet(input)

  browser.setSize = (width, height) ->
    size = { width: width, height: height }

  return browser

# --- exports ----------------------------------------------------------

window.Browser = Browser
