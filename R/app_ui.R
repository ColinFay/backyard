#' @importFrom shiny fluidPage includeCSS uiOutput
app_ui <- function(request) {
  fluidPage(
    includeCSS(system.file("www/custom.css", package = "backyard")),
    uiOutput("ui")
  )
}

