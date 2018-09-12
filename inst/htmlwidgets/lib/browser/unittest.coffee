registerTests = (sampleData) ->
  assert = chai.assert
  suite  = Mocha.suite
  test   = Mocha.test

  suite 'Idioms', () ->
    test 'clone array and elements', () ->
      x = [{x: 1}, {x: 2}]
      y = x.map (e) -> { e... }
      y[0].x = 3
      assert.equal(x[0].x, 1)

if window
  window.registerTests = registerTests
