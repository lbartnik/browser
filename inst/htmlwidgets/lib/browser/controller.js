"use strict";

// Generated by CoffeeScript 2.3.1
(function () {
  // --- KeyboardController -----------------------------------------------
  var KeyboardController;

  KeyboardController = function KeyboardController(view) {
    var callbacks, keyDown, keyboardController, translateKey;
    callbacks = {};
    keyboardController = function keyboardController() {};
    keyboardController.initialize = function () {
      return $(window).on('keydown', keyDown);
    };
    keyboardController.addCallback = function (key, cb) {
      return view = newView;
    };
    // --- keyboard signal callback
    keyDown = function keyDown(e) {
      var key;
      key = translateKey(e);
      if (view && view.keyboardSignal.call(this, key)) {
        return e.preventDefault();
      }
    };
    // --- translate key to its name
    translateKey = function translateKey(e) {
      var Codes, keyCode, ref;
      Codes = {
        13: "enter",
        37: "left",
        38: "up",
        39: "right",
        40: "down"
      };
      keyCode = (ref = e.originalEvent) != null ? ref.keyCode : void 0;
      if (keyCode in Codes) {
        return Codes[keyCode];
      }
      return null;
    };
    // --- return the controller object -----------------------------------
    keyboardController.initialize();
    return keyboardController;
  };

  // --- exports ----------------------------------------------------------
  window.KeyboardController = KeyboardController;
}).call(undefined);