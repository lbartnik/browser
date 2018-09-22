#!/bin/bash

./node_modules/.bin/coffee -c -w -t  lib/browser/ &
python -m SimpleHTTPServer 8000

