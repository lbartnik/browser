# --- KeyboardController -----------------------------------------------
KeyboardController = (view) ->
  callbacks = {}

  keyboardController = () ->

  keyboardController.initialize = () ->
    $(window).on 'keydown', keyDown

  keyboardController.addCallback = (key, cb) ->
    callbacks

  # --- keyboard signal callback
  keyDown = (e) ->
    key = translateKey(e)
    if view and view.keyboardSignal.call(this, key)
      e.preventDefault()

  # --- translate key to its name
  translateKey = (e) ->
    Codes =
      13: "enter",
      37: "left",
      38: "up",
      39: "right",
      40: "down"
    keyCode = e.originalEvent?.keyCode
    if keyCode of Codes then return Codes[keyCode]
    return null


  # --- return the controller object -----------------------------------
  keyboardController.initialize()
  keyboardController


# --- exports ----------------------------------------------------------

window.KeyboardController = KeyboardController
