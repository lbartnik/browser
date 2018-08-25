#' Widget API.
#'
#' @description `prepare_plots` pre-processes the list of artifacts and
#' either:
#'
#' * extracts plots into `png` files which are then attached to the
#'   html widget via `dependencies` (see [htmltools::htmlDependency])
#' * embeds the png bitmap as base64-encoded string under the `contents`
#'   key
#'
#' `png` files are stored in a temporary directory persisting throughout
#' the R session. Subsequent calls to `prepare_plots` will only process
#' new plots and thus be faster.
#'
#' @param embed Whether to embed plots as base64-encoded strings.
#' @param data container of artifacts; see [repository::is_container()].
#' @return A `list` with two elements: the `data` container possibly with
#' embedded plots; widget dependencies `html_deps`.
#'
#' @rdname widget
create_widget <- function (data) {
  if (is_knitr()) {
    data <- prepare_plots(data, NULL)
    deps <- list()
  } else {
    deps_dir <- file.path(tempdir(), 'browser-html-deps')
    dir.create(deps_dir, showWarnings = FALSE)
    deps <- extract_html_deps(data, deps_dir)
  }

  # create the widget
  htmlwidgets::createWidget("browser",
                            list(data = data,
                                 options = list(
                                   knitr = is_knitr()
                                 )),
                            dependencies = deps)
}


prepare_plots <- function (data, path = tempdir()) {
  stopifnot(is_container(data))

  # TODO plots could also be lazy loaded from within the browser; widget still needs access to repo; knitr remains a special case

  if (is.null(path)) {
    lapply(data, function (a) {
      if (!artifact_is(a, 'plot')) return(a)
      a$png <- artifact_data(a)$png
      a
    })
  } else {
    lapply(data, function (a) {
      if (!artifact_is(a, 'plot')) return(a)
      file <- file(file.path(path, paste0(a$id, '.png')), "wb", raw = TRUE)
      writeBin(artifact_data(a)$png, file) # TODO base64_decode
      close(file)
      a
    })
  }
}


extract_html_deps <- function (data) {
  plots <- Filter(function (a) artifact_is(a, 'plot'), data)
  ids    <- map_chr(plots, `[[`, 'id')
  paths  <- paste0(ids, '.png')

  deps <-
    list(
      htmltools::htmlDependency(
        "plots",
        version = "1",
        src = html_dir,
        attachment = with_names(paths, ids)
      )
    )
}
