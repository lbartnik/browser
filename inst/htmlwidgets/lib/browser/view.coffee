# --- TextTreeView -----------------------------------------------------
TextTreeView = (container, model) ->
  view = $('<div>', {class: 'view'}).appendTo(container)

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

    topUl = $('<ul>').appendTo(view)
    htmlSelf = $('<li>').appendTo(topUl)
    htmlChildren = $('<ul>').appendTo(htmlSelf)
    root = {htmlChildren: topUl}

    model.traverseAsTree(visit, {htmlChildren: htmlChildren})

  # --- creates a <div> for each data element, they are all assigned
  #     to the main container
  flatView = () ->
    create = (node, parent) ->
      node.element = $('<div>', {
          class: 'flat-artifact',
        })
        .appendTo(view)
        .append(artifactDescription(node))
    position = (node, parent) ->
      node.left = parent.left + 20
      node.element.css({left: node.left})

    model.traverseAsTree(create, null)
    model.traverseAsTree(position, {left: 0})
  
  artifactDescription = (a) ->
    element = $("<div>")
      .load $("#browser-1-attachment").attr("href"), null, () ->
        element.find(".name").text(a.name)
        element.find(".description").text(a.description)
        element.find("code")
          .text(a.expression)
          .each (i, block) -> hljs.highlightBlock(block)
    element


  # --- return the view object -----------------------------------------
  log.debug('created view')
  return textTreeView


# --- exports ----------------------------------------------------------

window.TextTreeView = TextTreeView
