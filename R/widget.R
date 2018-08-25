create_widget <- function (data) {
  stopifnot(is_container(data))

  processed <- plot_to_dependencies(steps$steps, is_knitr())
  steps$steps <- processed$steps
  options$knitr <- is_knitr()

  # create the widget
  htmlwidgets::createWidget("browser", list(data = steps, options = options),
                            dependencies = processed$html_deps)
}


#' Internal widget API.
#'
#' @description `prepare_plots` processes the `steps` list and either:
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
#' @rdname widget-internal
prepare_plots <- function (data, embed = is_knitr())
{
  html_dir <- file.path(tempdir(), 'browser-html-deps')
  dir.create(html_dir, showWarnings = FALSE)

  data <- lapply(data, function (a) {
    if (!artifact_is(a, 'plot')) return(a)

    # TODO will need to access the storage; is each artifact going to carry its storage as an attribute?
    # TODO plots could also be lazy loaded from within the browser; widget still needs access to repo; knitr remains a special case

    if (isTRUE(embed)) {
      a$png <- storage::os_read_object(store, a$id)$png
    } else {
      file <- file(file.path(html_dir, paste0(a$id, '.png')))
      writeBin(storage::os_read_object(store, a$id)$png, file)
      close(file)
    }

    a
  })

  if (isTRUE(embed)) {
    deps <- list()
  }
  else {
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

  list(steps = steps, html_deps = deps)
}

