browserOutput <- function(outputId, width = '100%', height = '100%') {
  htmlwidgets::shinyWidgetOutput(outputId, "browser", width, height, package = "browser")
}

renderBrowser <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) }
  htmlwidgets::shinyRenderWidget(expr, browserOutput, env, quoted = TRUE)
}



#' RStudio AddIn function.
#'
#' @description `browserAddin` runs the `htmlwidget` implemented in this
#' package as a RStudio AddIn (see [shiny::runGadget] for details).
#'
#' @param data Rree of artifacts data structure, see [repository] for more details.
#'
#' @export
#' @import miniUI
#' @importFrom shiny dialogViewer observeEvent runGadget shinyUI stopApp
browserAddin <- function (data)
{
  # error checking
  stopifnot(is_steps(steps))
  if (!count(steps)) {
    stop('history is empty, not showing the browser', call. = FALSE)
  }
  if (is.na(internal_state$task_callback_id)) {
    stop('tracking must be turned on in inder to open the widget',
         call. = FALSE)
  }

  # instructions on what to do with this widget
  if (!isTRUE(gui_state$popup_clicked)) {
    showDialog("Information",
       'In the Interactive History browser, choose a node (an object or a plot)',
       'on the graph. When the choice is made, click on the "Done" button and',
       'this will restore the state of R session when that object or plot was created.'
    )
    gui_state$popup_clicked <- TRUE
  }

  # --- the actual widget ---

  ui <- shinyUI(miniPage(
    gadgetTitleBar(title = "Interactive Object Browser",
                   left  = miniTitleBarCancelButton(),
                   right = miniTitleBarButton("done", "Done", primary = TRUE)),
    miniContentPanel(experimentOutput('experiment'),
                     padding = 15, scrollable = FALSE)
  ))

  server <- function(input, output) {
    output$experiment <- renderExperiment(render_steps(steps))

    # we can safely assume that tracking is turned on, otherwise there
    # would be no history to look at
    observeEvent(input$done, {
      if (is_empty(input$object_selected)) {
        cat('\nSelection empty, R session left unchanged.\n')
        hline()
      } else {
        st <- step_by(steps, input$object_selected)
        onRestore(st$commit_id)
      }

      stopApp(invisible(TRUE))
    })

    observeEvent(input$cancel, {
      cat('\nUser cancel, commit will not be restored.\n')
      hline()
      stopApp(invisible(FALSE))
    })

    observe({
      if (!is_empty(input$object_selected))
        onClick(steps, input$object_selected)
    })

    observe({
      if (!is_empty(input$comment) && !is_empty(input$object_selected))
        onCommentChange(steps, input$object_selected, input$comment)
    })
  }

  suppressMessages({
    runGadget(ui, server, viewer = dialogViewer("Interactive Browser", width = 750),
              stopOnCancel = FALSE)
  })
}


hline <- function ()  cat0(paste(rep_len('-', getOption('width')), collapse = ''), '\n\n')

onClick <- function (steps, id)
{
  stopifnot(!is_empty(id))

  st <- step_by(steps, id = id)
  co <- commit_restore(st$commit_id, internal_state$stash, .data = FALSE)

  cat('\n')
  cat0(crayon::green ('Chosen'), ': ', st$type, ' `', st$name, '` (id: ', st$id, ')\n')
  cat0(crayon::yellow('belongs to commit'), ': ', co$id, '\n')
  cat0('\n')

  print(co, header = FALSE)
}


onCommentChange <- function (steps, id, comment)
{
  st <- step_by(steps, id = id)
  tags <- storage::os_read_tags(internal_state$stash, st$object_id)
  tags$comment <- comment
  storage::os_update_tags(internal_state$stash, st$object_id, tags)
}


onRestore <- function (commit_id)
{
  cat0('\n\n', crayon::green('Restoring commit'), ': ', commit_id, '\n')
  hline()
  restore_commit(internal_state, commit_id, globalenv())
}





# temporary utility function
attachStore <- function (path = file.path(getwd(), "project-store"))
{
  store <- prepare_object_store(path)
  reattach_to_store(internal_state, store, globalenv(), "overwrite")
  invisible()
}


# --- basic history viewer ---------------------------------------------

historyOutput <- function(outputId, width = '100%', height = '100%') {
  htmlwidgets::shinyWidgetOutput(outputId, "browse", width, height, package = "experiment")
}

renderHistory <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) }
  htmlwidgets::shinyRenderWidget(expr, historyOutput, env, quoted = TRUE)
}


#' @import miniUI
#' @importFrom shiny browserViewer dialogViewer observeEvent runGadget shinyUI stopApp textOutput
historyGadget <- function (g = list(), browser = FALSE)
{
  stopifnot(is_graph(g))

  ui <- shinyUI(miniPage(
    gadgetTitleBar(title = "Basic History Browser",
                   left  = miniTitleBarCancelButton(),
                   right = miniTitleBarButton("done", "Done", primary = TRUE)),
    miniContentPanel(historyOutput('viewer'),
                     textOutput('closeWindow'),
                     padding = 15, scrollable = TRUE)
  ))


  data       <- graph_to_viewer(g)
  processed  <- plot_to_dependencies(data$steps, is_knitr())
  data$steps <- processed$steps

  options    <- list(knitr = is_knitr())

  server <- function(input, output) {
    output$viewer <- renderHistory(htmlwidgets::createWidget("browse", list(data = data, options = options),
                                                             dependencies = processed$html_deps))

    observeEvent(input$done, { stopApp(TRUE) })
    observeEvent(input$cancel, { stopApp(FALSE) })
  }

  viewer <- if (isTRUE(browser)) browserViewer() else dialogViewer("Interactive Browser")
  runGadget(ui, server, viewer = viewer, stopOnCancel = FALSE)
}


graph_to_viewer <- function (g)
{
  stopifnot(is_graph(g))

  s <- graph_to_steps(g)

  g <- lapply(g, function (commit) {
    commit$introduced <- introduced_in(g, commit$id)
    commit$objects    <- commit$object_ids
    commit$object_ids <- NULL
    commit$expr <- format_expression(commit$expr)
    commit
  })

  c(list(commits = g), s)
}


# --- unit tests in browser --------------------------------------------

unittestOutput <- function(outputId, width = '100%', height = '100%') {
  htmlwidgets::shinyWidgetOutput(outputId, "unittest", width, height, package = "experiment")
}

renderUnittest <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) }
  htmlwidgets::shinyRenderWidget(expr, unittestOutput, env, quoted = TRUE)
}


#' @import miniUI
#' @importFrom shiny browserViewer dialogViewer observeEvent runGadget shinyUI stopApp textOutput
unittestGadget <- function (data = system.file("htmlwidgets/data-1/data.json", package = 'experiment'),
                            browser = FALSE, autoClose = TRUE, port = NULL)
{
  if (is.character(data)) {
    data <- jsonlite::fromJSON(data, simplifyVector = FALSE)
  }

  ui <- shinyUI(miniPage(
    gadgetTitleBar(title = "Interactive Object Browser",
                   left  = miniTitleBarCancelButton(),
                   right = miniTitleBarButton("done", "Done", primary = TRUE)),
    miniContentPanel(unittestOutput('unittest'),
                     textOutput('closeWindow'),
                     padding = 15, scrollable = TRUE)
  ))

  server <- function(input, output) {
    stopApp <- function (rc) {
      if (!isTRUE(autoClose)) return()
      output$closeWindow <- renderText('done')
      shiny::stopApp(rc)
    }

    output$unittest <- renderUnittest(htmlwidgets::createWidget("unittest", list(data = data)))

    observeEvent(input$done, { stopApp(TRUE) })
    observeEvent(input$cancel, { stopApp(FALSE) })
  }

  viewer <- if (isTRUE(browser)) browserViewer() else dialogViewer("Interactive Browser")
  runGadget(ui, server, viewer = viewer, stopOnCancel = FALSE, port = port)
}