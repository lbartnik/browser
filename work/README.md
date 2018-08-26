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
  ~/Projects/third-party/node/node_modules/.bin/coffee -w -t -c script.coffee
```

If the JavaScript file is supposed to be used in RStudio, babel
transcompilations need to be applied as well. RStudio comes with
a little bit older JavaScript interpreter than e.g. Chrome does.
