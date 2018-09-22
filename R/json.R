prepareJSON <- function (x) UseMethod("prepareJSON")

#' @export
prepareJSON.default <- function (x) abort(glue("don't know how to prepare {class(x)}"))

#' @export
prepareJSON.container <- function (x) {
  lapply(x, prepareJSON)
}

#' @importFrom jsonlite unbox
#' @export
prepareJSON.artifact <- function (x) {
  class(x) <- NULL

  x$id <- unbox(x$id)
  x$name <- unbox(x$name)
  x$time <- unbox(x$time)
  x$description <- unbox(x$description)
  x$expression <- unbox(x$expression)
  x
}
