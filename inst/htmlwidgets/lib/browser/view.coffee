# --- TextTreeView -----------------------------------------------------
TextTreeView = (external, model) ->
  container = $('<div>', {class: 'view'}).appendTo(external)

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
    element = $("<div>")
      .load $("#browser-1-attachment").attr("href"), null, () ->
        element.find(".name").text(a.name)
        element.find(".description").text(a.description)
        element.find("code")
          .text(a.expression)
          .each (i, block) -> hljs.highlightBlock(block)
    element

  # --- interactions ---------------------------------------------------
  selectArtifact = (event) ->
    console.log('jest')
    container.find('.flat-artifact').removeClass('selected')
    $(this).addClass('selected')


  # --- return the view object -----------------------------------------
  log.debug('created view')
  return textTreeView


# --- exports ----------------------------------------------------------

window.TextTreeView = TextTreeView
