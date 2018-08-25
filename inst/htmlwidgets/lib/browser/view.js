/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
// --- Browser ----------------------------------------------------------
const Browser = function(element) {
  const options  = { shiny: false, knitr: false };
  let data     = null;
  let size     = { width: 800, height: 600 };

  const browser = function() {};

  browser.setData = input => data = DataSet(input);

  browser.setSize = (width, height) => size = { width, height };

  return browser;
};

// --- exports ----------------------------------------------------------

window.Browser = Browser;
