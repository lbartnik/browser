context("json")

test_that("container is prepared", {
  d <- list(1, 2, 3)
  c <- structure(d, class = 'container')

  expect_equal(prepareJSON(c), d)
})

test_that("artifact is prepared", {
  tags <- list(id = 'id', name = 'name', names = 'name', class = 'class',
               parents = 'parents', expression = bquote(x), time = 1)
  a <- repository:::as_artifact(tags)

  x <- prepareJSON(a)
  expect_equal(class(x), "list")
  expect_named(x, names(a), ignore.order = TRUE)
})
