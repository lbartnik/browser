context("widget")

test_that("plots are embedded", {
  a <- read_artifacts(as_artifacts(sample_repository()))

  # preconditions: no plots are loaded yet
  expect_true(all(map_lgl(a, function(x) is.null(x$png))))

  d <- expect_silent(prepare_plots(a, NULL))
  expect_true(all(
    map_lgl(d, function (x) xor(artifact_is(x, 'plot'), is.null(x$png)))
  ))
})

test_that("plots are stored in filesystem", {
  a <- read_artifacts(as_artifacts(sample_repository()))

  path <- file.path(tempdir(), 'browser-html-deps')
  on.exit(unlink(path, TRUE, TRUE))

  # preconditions: no plots are loaded yet; directory does not exist
  expect_true(all(map_lgl(a, function(x) is.null(x$png))))
  expect_false(dir.exists(path))

  expect_true(dir.create(path, FALSE, TRUE))
  expect_silent(prepare_plots(a, path))

  expect_true(dir.exists(path))
  expect_length(list.files(path), 6)
})
