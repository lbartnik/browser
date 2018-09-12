# --- ArtifactView -----------------------------------------------------
ArtifactView = (external, model) ->
  container = $('<div>', {class: 'artifact-view'}).appendTo(external)
  templateUrl = $("#browser-1-attachment").attr("href")

  initiate = () ->
    element = $("<div>")
    element.load templateUrl, null, () ->
      element.find(".name").text(model.name)
      element.find(".description").text(model.description)
      element.find("code")
        .text(model.expression)
        .each (i, block) -> hljs.highlightBlock(block)
      element.find('.code-block').addClass('invisible')
      #element.

  artifactView = () ->

  artifactView.keypressEnter = () -> 
    container.find('.selected').find('.code-block').toggleClass('invisible')




# --- TextTreeView -----------------------------------------------------
TextTreeView = (external, model) ->
  container = $('<div>', {class: 'tree-view'}).appendTo(external)

  textTreeView = () ->

  # --- refresh view ---------------------------------------------------
  textTreeView.refresh = () ->
    if false
      listBasedView()
    else
      flatView()

  # --- creates a number of nested, unordered lists
  listBasedView = () ->
    visit = (node, parent) ->
      node.htmlSelf = $('<li>').appendTo(parent.htmlChildren)
      node.htmlChildren = $('<ul>').appendTo(node.htmlSelf)

    topUl = $('<ul>').appendTo(container)
    htmlSelf = $('<li>').appendTo(topUl)
    htmlChildren = $('<ul>').appendTo(htmlSelf)
    root = {htmlChildren: topUl}

    model.traverseAsTree(visit, {htmlChildren: htmlChildren})

  # --- creates a <div> for each data element, they are all assigned
  #     to the main container
  flatView = () ->
    create = (node, parent) ->
      node.left = parent.left + 20
      node.element = $('<div>', {
          class: 'flat-artifact',
        })
        .css({left: node.left})
        .on('click', node, selectArtifact)
        .appendTo(container)
        .append(artifactDescription(node))
    model.traverseAsTree(create, {left: 0})
  
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
