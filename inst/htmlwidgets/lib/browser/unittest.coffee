# requires mocha.setup('tdd') to be called before loading this file

suite 'Idioms', () ->
  test 'clone array and elements', () ->
    x = [{x: 1}, {x: 2}]
    y = x.map (e) -> { e... }
    y[0].x = 3
    chai.assert.equal(x[0].x, 1)
