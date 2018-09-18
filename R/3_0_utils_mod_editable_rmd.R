
#' @importFrom shiny NS tagList tags HTML verbatimTextOutput actionButton
mod_editable_rmdui <- function(id){
  ns <- shiny::NS(id)
  shiny::tagList(
    shiny::tags$style(shiny::HTML('pre {border: none}')),
    shiny::tags$div(
      id = ns("editable"),
      contenteditable="true",
      style = "background-color: #f5f5f5; border: 1px solid #ccc;",
      shiny::verbatimTextOutput(ns("out"))
    ),
    shiny::actionButton(ns("save"), "Save"),
    shiny::tags$br(),
    shiny::tags$script(paste0('
      document.getElementById("', ns("save"), '").onclick = function() {
      var x = document.getElementById("', ns("out"), '").textContent;
      Shiny.onInputChange("', ns("fromjs"), '", x);
    };'))

  )
}

#' @importFrom glue as_glue
#' @importFrom shiny renderPrint observeEvent
#' @importFrom yaml as.yaml
mod_editable_rmd <- function(input, output, session, rmd, r){
  ns <- session$ns
  output$out <- shiny::renderPrint({

    if (basename(rmd) == basename(r$index$path)){
      tf <- tempfile(fileext = ".Rmd")
      write(r$index$content, tf)
      rmd <- tf
    }
    glue::as_glue(readLines(rmd))
  })

  shiny::observeEvent(input$fromjs, {
    res <- input$fromjs

    if (basename(rmd) == basename(r$index$path)){
      r$index$content <- res
      res <- paste0("---", yaml::as.yaml(r$index_yml), "---", res)
    }

    write(res, rmd)

    saved()
  })
}

#library(shiny)

# ui <- fluidPage(
#   mod_editable_rmdui("test")
# )
#
# server <- function(input, output, session){
#   callModule(mod_editable_rmd, "test", rmd = "inst/bookdown/01-intro.Rmd")
# }
#
# shinyApp(ui, server)
