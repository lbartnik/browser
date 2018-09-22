#' RStudio AddIn.
#'
#' @description `browser_addin` runs the `htmlwidget` implemented in this
#' package as a RStudio AddIn (see [shiny::runGadget] for details).
#'
#' @param data Container with artifacts; see [repository::read_artifacts()]
#'        for more details.
#'
#' @import miniUI
#' @importFrom shiny browserViewer dialogViewer observeEvent runGadget shinyUI stopApp
#' @export
#' @rdname addin
browser_addin <- function (data, .inBrowser = FALSE)
{
  stopifnot(is_container(data))

  if (!length(data)) {
    abort('history is empty, not showing the browser')
  }

  ui <- shinyUI(miniPage(
    gadgetTitleBar(title = "Artifact Browser",
                   left  = miniTitleBarCancelButton(),
                   right = miniTitleBarButton("done", "Done", primary = TRUE)),
    miniContentPanel(browser_output('browser'),
                     padding = 15, scrollable = FALSE)
  ))

  server <- function(input, output) {
    output$browser <- render_browser(create_widget(data))

    # tracking has to be turned on, otherwise there is no history to look at
    observeEvent(input$done, {
      stopApp(invisible(TRUE))
    })

    observeEvent(input$cancel, {
      warn('User cancelled.')
      stopApp(invisible(FALSE))
    })

    observeEvent(input$exception, {
      warn(glue("Caught JS exception: {input$exception}"))
      stopApp(invisible(FALSE))
    })
  }


  suppressMessages({
    viewer <- if (isTRUE(.inBrowser)) browserViewer() else dialogViewer("Artifact Browser", width = 750)
    runGadget(ui, server, viewer = viewer, stopOnCancel = FALSE)
  })
}


browser_output <- function(outputId, width = '100%', height = '100%') {
  htmlwidgets::shinyWidgetOutput(outputId, "browser", width, height, package = "browser")
}

render_browser <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) }
  htmlwidgets::shinyRenderWidget(expr, browser_output, env, quoted = TRUE)
}
