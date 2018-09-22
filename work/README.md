Development
===========

Run a local HTTP server

```bash
python server.py
```

Convert CoffeeScript to JS

Compiling a CoffeeScript into JavaScript

```bash
  <path-to-coffee>/coffee -w -t -c script.coffee
```

Example:

```bash
  ./node_modules/.bin/coffee -w -t -c lib/browser/
```

If the JavaScript file is supposed to be used in RStudio, babel
transcompilations need to be applied as well. RStudio comes with
a little bit older JavaScript interpreter than e.g. Chrome does.

Installing all required `node` modules:

```bash
npm install --save-dev coffeescript
npm install --save-dev babel-core babel-preset-env
npm install --save-dev babel-plugin-transform-object-rest-spread
```

Warning! The `coffee` package is actually CoffeeScript v1.
