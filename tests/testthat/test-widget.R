context("widget")

test_that("plots are prepared", {
  a <- read_artifacts(as_artifacts(sample_repository()))

  # preconditions: this is where plots will be stored
  path <- file.path(tempdir(), 'browser-html-deps')
  unlink(path, TRUE, TRUE)
  expect_false(dir.exists(path))

  # preconditions: no plots are loaded yet
  expect_true(all(map_lgl(a, function(x) is.null(x$png))))

  # embed PNG in data
  d <- expect_silent(prepare_plots(a, TRUE))
  expect_true(all(
    map_lgl(d, function (x) xor(artifact_is(x, 'plot'), is.null(x$png)))
  ))

  expect_false(dir.exists(path))

  # put files on disk
  expect_silent(prepare_plots(a, FALSE))

  expect_true(dir.exists(path))
  expect_length(list.files(path), 6)
})



