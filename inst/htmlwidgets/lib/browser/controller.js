/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
// --- KeyboardController -----------------------------------------------
const KeyboardController = function(view) {

  const keyboardController = function() {};

  keyboardController.initialize = () => $(window).on('keydown', keyDown);

  keyboardController.setView = newView => view = newView;

  // --- keyboard signal callback
  var keyDown = function(e) {
    const key = translateKey(e);
    if (view && view.keyboardSignal.call(this, key)) {
      return e.preventDefault();
    }
  };

  // --- translate key to its name
  var translateKey = function(e) {
    const Codes = {
      13: "enter",
      37: "left",
      38: "up",
      39: "right",
      40: "down"
    };
    const keyCode = e.originalEvent != null ? e.originalEvent.keyCode : undefined;
    if (keyCode in Codes) { return Codes[keyCode]; }
    return null;
  };


  // --- return the controller object -----------------------------------
  keyboardController.initialize();
  return keyboardController;
};


// --- exports ----------------------------------------------------------

window.KeyboardController = KeyboardController;
