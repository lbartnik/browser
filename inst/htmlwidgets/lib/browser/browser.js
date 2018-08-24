/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
// --- Browser ----------------------------------------------------------
const Browser = function(element) {
  const options   = { shiny: false, knitr: false };
  let size      = { width: 800, height: 600 };
  let container = null;
  let view      = null;
  let model     = null;

  const initialize = function() {
    options.shiny = ((typeof HTMLWidgets !== 'undefined') && HTMLWidgets.shinyMode);
    element = $(element);
    return container = $("<div>", {class: "main-container"}).appendTo(element);
  };

  const browser = function() {};

  browser.setData = function(raw) {
    model = DataSet(raw);
    view  = TextTreeView(container, model);
    return view.refresh();
  };

  browser.setSize = (width, height) => size = { width, height };

  initialize();
  return browser;
};

// --- exports ----------------------------------------------------------

window.Browser = Browser;
