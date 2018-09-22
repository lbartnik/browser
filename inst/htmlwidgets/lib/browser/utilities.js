"use strict";

// Generated by CoffeeScript 2.3.1
(function () {
  var Log, Viewport, sign;

  Array.prototype.unique = function () {
    var i, key, output, ref, ref1, results, value;
    output = {};
    for (key = i = 0, ref = this.length; 0 <= ref ? i < ref : i > ref; key = 0 <= ref ? ++i : --i) {
      output[(ref1 = this[key].id) != null ? ref1 : this[key]] = this[key];
    }
    results = [];
    for (key in output) {
      value = output[key];
      results.push(value);
    }
    return results;
  };

  Array.prototype.min = function () {
    return this.reduce(function (a, b) {
      return Math.min(a, b);
    });
  };

  Array.prototype.max = function () {
    return this.reduce(function (a, b) {
      return Math.max(a, b);
    });
  };

  Array.prototype.remove = function (e) {
    return this.filter(function (el) {
      return el !== e;
    });
  };

  Array.prototype.last = function () {
    return this[this.length - 1];
  };

  if (Math.sign === void 0) {
    sign = function sign(x) {
      if (x < 0) {
        return -1;
      } else {
        return 1;
      }
    };
  } else {
    sign = Math.sign;
  }

  // --- simple logger ----------------------------------------------------
  Log = function Log() {
    var callerName, enabled, log, showMessage;
    enabled = false;
    callerName = function callerName() {
      var re, res, st;
      re = /([^(]+)@|at ([^(]+) \(/gm;
      st = new Error().stack;
      re.exec(st); // skip 1st line
      re.exec(st); // skip 2nd line
      re.exec(st); // skip 3rd line
      res = re.exec(st);
      if (!res) {
        return "unknown";
      }
      return res[1] || res[2];
    };
    showMessage = function showMessage(level, message) {
      var caller;
      if (!enabled) {
        return;
      }
      caller = callerName();
      return console.log(level + " " + caller + ": " + message);
    };
    log = function log() {};
    log.debug = function (message) {
      return showMessage("DEBUG", message);
    };
    log.info = function (message) {
      return showMessage("INFO ", message);
    };
    log.enable = function (onoff) {
      return enabled = onoff;
    };
    return log;
  };

  Viewport = function Viewport(selection) {
    var viewport;
    viewport = function viewport() {};
    viewport.size = function () {
      var h, w;
      // actual viewport; in R Studio, when running as AddIn, this is somehow
      // distorted and reports size larger than the actual viewport area
      w = Math.max(document.documentElement.clientWidth, window.innerWidth || 0);
      h = Math.max(document.documentElement.clientHeight, window.innerHeight || 0);
      // thus, we compare it with the size of the enclosing HTML element and
      // choose whatever is smaller
      w = Math.min(w, $(selection).width());
      h = Math.min(h, $(selection).height());
      return {
        width: w,
        height: h
      };
    };
    return viewport;
  };

  // --- exports ----------------------------------------------------------
  window.log = Log();
}).call(undefined);