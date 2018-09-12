'use strict';

var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };

// Generated by CoffeeScript 2.3.1
(function () {
  var registerTests;

  registerTests = function registerTests(sampleData) {
    var assert, suite, test;
    assert = chai.assert;
    suite = Mocha.suite;
    test = Mocha.test;
    return suite('Idioms', function () {
      return test('clone array and elements', function () {
        var x, y;
        x = [{
          x: 1
        }, {
          x: 2
        }];
        y = x.map(function (e) {
          return _extends({}, e);
        });
        y[0].x = 3;
        return assert.equal(x[0].x, 1);
      });
    });
  };

  if (window) {
    window.registerTests = registerTests;
  }
}).call(undefined);