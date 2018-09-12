context("js.test")

test_that("basic js unit tests", {
  skip_if_not_installed("V8")

  ct <- v8(global = "window", console = TRUE)
  ct$source("inst/htmlwidgets/lib/chai-4.1.2/chai.js")
  ct$source("inst/htmlwidgets/lib/mocha-5.2.0/mocha.js")
  ct$source("inst/htmlwidgets/lib/browser/view.js")
  ct$source("inst/htmlwidgets/lib/browser/unittest.js")

  ct$eval("registerTests()")
  ct$console()
  ct$get("Object.keys(window)")
})
