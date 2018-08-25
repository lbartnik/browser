/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS202: Simplify dynamic range loops
 * DS205: Consider reworking code to avoid use of IIFEs
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let sign;
Array.prototype.unique = function() {
  let key;
  let asc, end;
  const output = {};
  for (key = 0, end = this.length, asc = 0 <= end; asc ? key < end : key > end; asc ? key++ : key--) { output[this[key].id != null ? this[key].id : this[key]] = this[key]; }
  return (() => {
    const result = [];
    for (key in output) {
      const value = output[key];
      result.push(value);
    }
    return result;
  })();
};

Array.prototype.min = function() {
  return this.reduce((a,b) => Math.min(a, b));
};

Array.prototype.max = function() {
  return this.reduce((a,b) => Math.max(a, b));
};

Array.prototype.remove = function(e) {
  return this.filter(el => el !== e);
};

if (Math.sign === undefined) {
  sign = function(x) { if (x < 0) { return -1; } else { return 1; } };
} else {
  ({ sign } = Math);
}

// --- simple logger ----------------------------------------------------
const Log = function() {
  let enabled = false;

  const callerName = function() {
    const re = /([^(]+)@|at ([^(]+) \(/gm;
    const st = new Error().stack;
    re.exec(st); // skip 1st line
    re.exec(st); // skip 2nd line
    re.exec(st); // skip 3rd line
    const res = re.exec(st);
    if (!res) { return "unknown"; }
    return res[1] || res[2];
  };
  
  const showMessage = function(level, message) {
    if (!enabled) { return; }
    const caller = callerName();
    return console.log(`${level} ${caller}: ${message}`);
  };

  const log = function() {};
  log.debug = message => showMessage("DEBUG", message);
  log.info  = message => showMessage("INFO ", message);

  log.enable = onoff => enabled = onoff;

  return log;
};


const Viewport = function(selection) {
  const viewport = function() {};
  viewport.size = function() {
    // actual viewport; in R Studio, when running as AddIn, this is somehow
    // distorted and reports size larger than the actual viewport area
    let w = Math.max(document.documentElement.clientWidth, window.innerWidth || 0);
    let h = Math.max(document.documentElement.clientHeight, window.innerHeight || 0);
    // thus, we compare it with the size of the enclosing HTML element and
    // choose whatever is smaller
    w = Math.min(w, $(selection).width());
    h = Math.min(h, $(selection).height());
    return {width: w, height: h};
  };
  return viewport;
};


// --- exports ----------------------------------------------------------

window.log = Log();
