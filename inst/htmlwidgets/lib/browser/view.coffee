# --- TextTreeView -----------------------------------------------------
TextTreeView = (container, model) ->

  textTreeView = () ->

  textTreeView.refresh = () ->
    visit = (node, parent) ->
      node.htmlSelf = $('<li>').appendTo(parent.htmlChildren)
      node.htmlChildren = $('<ul>').appendTo(node.htmlSelf)

    topUl = $('<ul>').appendTo(container)
    htmlSelf = $('<li>').appendTo(topUl)
    htmlChildren = $('<ul>').appendTo(htmlSelf)
    root = {htmlChildren: topUl}

    tree = model.traverseAsTree(visit, {htmlChildren: htmlChildren})


  # --- return the view object -----------------------------------------
  log.debug('created view')
  return textTreeView


# --- exports ----------------------------------------------------------

window.TextTreeView = TextTreeView
