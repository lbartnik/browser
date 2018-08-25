/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
// --- TextTreeView -----------------------------------------------------
const TextTreeView = function(container, model) {

  const textTreeView = function() {};

  textTreeView.refresh = function() {
    let tree;
    const visit = function(node, parent) {
      node.htmlSelf = $('<li>').appendTo(parent.htmlChildren);
      return node.htmlChildren = $('<ul>').appendTo(node.htmlSelf);
    };

    const topUl = $('<ul>').appendTo(container);
    const htmlSelf = $('<li>').appendTo(topUl);
    const htmlChildren = $('<ul>').appendTo(htmlSelf);
    const root = {htmlChildren: topUl};

    return tree = model.traverseAsTree(visit, {htmlChildren});
  };


  // --- return the view object -----------------------------------------
  log.debug('created view');
  return textTreeView;
};


// --- exports ----------------------------------------------------------

window.TextTreeView = TextTreeView;
