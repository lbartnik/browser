context("js.test")

test_that("basic js unit tests", {
  skip_if_not_installed("V8")

  ct <- v8()
  ct$eval("window = {}")
  ct$source("inst/htmlwidgets/lib/chai-4.1.2/chai.js")
  ct$source("inst/htmlwidgets/lib/mocha-5.0.0/mocha.js")
  ct$source("inst/htmlwidgets/lib/browser/view.js")
  ct$source("inst/htmlwidgets/lib/browser/unittest.js")
  ct$eval("window.registerTests()")
})
