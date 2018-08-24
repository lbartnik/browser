Array::unique = () ->
  output = {}
  (output[@[key].id ? @[key]] = @[key]) for key in [0...@length]
  value for key, value of output

Array::min = () ->
  @.reduce((a,b) -> Math.min(a, b))

Array::max = () ->
  @.reduce((a,b) -> Math.max(a, b))

Array::remove = (e) ->
  @filter (el) -> el isnt e

if Math.sign is undefined
  sign = (x) -> if x < 0 then -1 else 1
else
  sign = Math.sign

# --- simple logger ----------------------------------------------------
Log = () ->
  enabled = false

  callerName = () ->
    re = /([^(]+)@|at ([^(]+) \(/gm
    st = new Error().stack
    re.exec(st) # skip 1st line
    re.exec(st) # skip 2nd line
    re.exec(st) # skip 3rd line
    res = re.exec(st)
    if not res then return "unknown"
    return res[1] || res[2]
  
  showMessage = (level, message) ->
    if not enabled then return
    caller = callerName()
    console.log("#{level} #{caller}: #{message}")

  log = () ->
  log.debug = (message) -> showMessage("DEBUG", message)
  log.info  = (message) -> showMessage("INFO ", message)

  log.enable = (onoff) ->
    enabled = onoff

  return log


Viewport = (selection) ->
  viewport = () ->
  viewport.size = () ->
    # actual viewport; in R Studio, when running as AddIn, this is somehow
    # distorted and reports size larger than the actual viewport area
    w = Math.max(document.documentElement.clientWidth, window.innerWidth || 0)
    h = Math.max(document.documentElement.clientHeight, window.innerHeight || 0)
    # thus, we compare it with the size of the enclosing HTML element and
    # choose whatever is smaller
    w = Math.min(w, $(selection).width())
    h = Math.min(h, $(selection).height())
    {width: w, height: h}
  return viewport


# --- exports ----------------------------------------------------------

window.log = Log()
