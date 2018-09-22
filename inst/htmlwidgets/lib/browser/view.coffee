# --- ArtifactView -----------------------------------------------------
#
# @param parent Parent HTML element.
# @param model  Artifact model (DTO).
# @param node   D3 tree node object.
#
ArtifactView = (model, parent) ->
  templateUrl = $("#browser-1-attachment").attr("href")

  initialize = () ->
    $.get templateUrl, (data) ->
      rendered = $("<div>")
      rendered.html(Mustache.render(data, model))
      rendered.find("code")
        .each (i, block) -> hljs.highlightBlock(block)
      rendered.find('.code-block').addClass('invisible')
      rendered.appendTo(parent)
      # TODO add event handlers

  artifactView = () ->

  artifactView.keypressEnter = () -> 
    container.find('.selected').find('.code-block').toggleClass('invisible')

  # return the instance
  initialize()
  artifactView


# --- TextTreeView -----------------------------------------------------
TextTreeView = (external, model) ->
  container = $('<div>', {class: 'tree-view'}).appendTo(external)

  textTreeView = () ->

  # --- refresh view ---------------------------------------------------
  textTreeView.refresh = () ->
    model.forEach (model) ->
      av = ArtifactView(model, container)
  
  # --- loads and fills artifact detailed description
  artifactDescription = (a) ->
    element

  # --- interactions ---------------------------------------------------
  textTreeView.keyboardSignal = (key) ->
    # TODO up/down - walk the list
    # TODO left/right - walk the tree
    if key is 'enter'
      return true

  selectArtifact = (event) ->
    container.find('.flat-artifact').removeClass('selected')
    $(this).addClass('selected')


  # --- return the view object -----------------------------------------
  log.debug('created view')
  return textTreeView


# --- exports ----------------------------------------------------------

window.TextTreeView = TextTreeView
window.ArtifactView = ArtifactView
