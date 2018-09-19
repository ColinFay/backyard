#' @importFrom shiny NS tagList h2 actionButton
mod_renderui <- function(id) {
  ns <- NS(id)
  tagList(
    h2("Download gitbook"),
    tags$i("Under construction")
    #actionButton(ns("dl"), 'Download')
  )
}

#' @importFrom bookdown render_book
#' @importFrom shiny observeEvent showModal isTruthy withProgress removeModal
#' @importFrom shinyFiles shinyDirChoose parseDirPath
#' @importFrom utils zip
#' @importFrom withr with_dir
mod_render <- function(input, output, session, r) {
#   ns <- session$ns
#
#   observeEvent(input$dl, {
#     showModal(dir_select(ns))
#   })
#
#   roots <- c(wd = getOption("bkyrdhome"))
#
#   shinyDirChoose(
#     input,
#     "dir",
#     roots = roots
#   )
#   observeEvent(input$okdl, {
#
#     if ( ! isTruthy(input$dir) ) {
#       showModal(dir_select(ns, failed = TRUE))
#       return(NULL)
#     }
#     withProgress(
#       message = "Rendering the book", {
#
#         ici <- normalizePath(parseDirPath(roots, input$dir))
#
#         #t <- tempdir()
#         with_dir(r$path, {
#           where <- render_book(input =  r$path, output_dir = normalizePath(parseDirPath(roots, input$dir)))
#         })
#         with_dir(t, {
#           zip(
#             paste0(ici, "/", input$namedir, ".zip"),
#             list.files(ici)
#           )
#         })
#
#   })
#     saved()
#     removeModal()
#   })
#
#   observeEvent(input$canceldl, {
#     showModal(dir_select(ns, failed = TRUE))
#     })
}

#' @importFrom shiny modalDialog tags textInput div tagList actionButton
#' @importFrom shinyFiles shinyDirButton
dir_select <- function(ns, failed = FALSE) {
  modalDialog(
    tags$strong(
      "Download Bookdown"
    ),
    shinyDirButton(
      ns("dir"),
      label = "Dir select",
      title = "Select a folder to save the zip directory"
    ),
    textInput(ns("namedir"), "Name of zip", "bookdown"),
    tags$hr(),
    if (failed) {
      div(tags$b("Please select a valid path", style = "color: red;"))
    },
    footer = tagList(
      actionButton(ns("canceldl"), "Cancel"),
      actionButton(ns("okdl"), "OK")
    )
  )
}
