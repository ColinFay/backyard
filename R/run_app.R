#' run the Shiny Application
#'
#' @inheritParams shiny::shinyApp
#' @param indexrmd the path to index.Rmd, if you want to launch from an already existing bookdown
#' @param home where should the directory/file selector widget start from
#' @param port port to run the Shiny app on, default is 2811.
#' @param ... options to be passed to `shinyApp`, options param
#'
#' @export
#' @importFrom shiny shinyApp
#'
#' @examples
#'
#' if (interactive()) {
#'
#'   run_app()
#'
#' }
#'
run_app <- function(indexrmd = NA, home = "~",
                    onStart = NULL, uiPattern = "/",
                    port = 2811, enableBookmarking = NULL, ...) {
  opts <- list(...)
  opts$port <- port
  if (!is.na(indexrmd)){
    indexrmd <- normalizePath(indexrmd)
  }
  options("bkyrd" = indexrmd)
  options("bkyrdhome" = home)
  shinyApp(ui = app_ui(), server = app_server, options = opts)
}
