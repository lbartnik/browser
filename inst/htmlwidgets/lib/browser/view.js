/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
// --- TextTreeView -----------------------------------------------------
const TextTreeView = function(external, model) {
  const container = $('<div>', {class: 'view'}).appendTo(external);

  const textTreeView = function() {};

  // --- refresh view ---------------------------------------------------
  textTreeView.refresh = function() {
    if (false) {
      return listBasedView();
    } else {
      return flatView();
    }
  };

  // --- creates a number of nested, unordered lists
  var listBasedView = function() {
    const visit = function(node, parent) {
      node.htmlSelf = $('<li>').appendTo(parent.htmlChildren);
      return node.htmlChildren = $('<ul>').appendTo(node.htmlSelf);
    };

    const topUl = $('<ul>').appendTo(container);
    const htmlSelf = $('<li>').appendTo(topUl);
    const htmlChildren = $('<ul>').appendTo(htmlSelf);
    const root = {htmlChildren: topUl};

    return model.traverseAsTree(visit, {htmlChildren});
  };

  // --- creates a <div> for each data element, they are all assigned
  //     to the main container
  var flatView = function() {
    const create = function(node, parent) {
      node.left = parent.left + 20;
      return node.element = $('<div>', {
          class: 'flat-artifact',
        })
        .css({left: node.left})
        .on('click', node, selectArtifact)
        .appendTo(container)
        .append(artifactDescription(node));
    };
    return model.traverseAsTree(create, {left: 0});
  };
  
  // --- loads and fills artifact detailed description
  var artifactDescription = function(a) {
    var element = $("<div>")
      .load($("#browser-1-attachment").attr("href"), null, function() {
        element.find(".name").text(a.name);
        element.find(".description").text(a.description);
        element.find("code")
          .text(a.expression)
          .each((i, block) => hljs.highlightBlock(block));
        return element.find('.code-block').addClass('invisible');
    });
    return element;
  };

  // --- interactions ---------------------------------------------------
  textTreeView.keyboardSignal = function(key) {
    // TODO up/down - walk the list
    // TODO left/right - walk the tree
    if (key === 'enter') {
      container.find('.selected').find('.code-block').toggleClass('invisible');
      return true;
    }
  };

  var selectArtifact = function(event) {
    container.find('.flat-artifact').removeClass('selected');
    return $(this).addClass('selected');
  };


  // --- return the view object -----------------------------------------
  log.debug('created view');
  return textTreeView;
};


// --- exports ----------------------------------------------------------

window.TextTreeView = TextTreeView;
