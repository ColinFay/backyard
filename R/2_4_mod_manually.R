#' @importFrom shiny NS tagList column h2 selectInput uiOutput tags actionButton
mod_yml_manuallyui <- function(id){
  ns <- NS(id)
  tagList(
    column(
      12,
      h2("Edit Options"),
      selectInput(ns("select_yml"), label = "Select the Options file to edit", choices = letters, width = "100%"),
      uiOutput(ns("ymlui")),
    tags$br(),
    actionButton(ns("save"), "Save"),
    tags$br()
    ),

    tags$script(paste0('
      document.getElementById("', ns("save"), '").onclick = function() {
      var x = document.getElementById("', ns("out"), '").textContent;
      Shiny.onInputChange("', ns("fromjs"), '", x);
    };'))

  )
}

#' @importFrom glue as_glue
#' @importFrom shiny reactiveValues observe req updateSelectInput observeEvent renderUI tagList tags HTML verbatimTextOutput renderPrint
mod_yml_manually <- function(input, output, session, r){
  ns <- session$ns
  selected <- reactiveValues(yml = NULL)
  yml <- reactiveValues(
    path = list.files(r$path, pattern = "yml$", full.names = TRUE)
  )

  observe({
    req(r$index$path)
    updateSelectInput(session, "select_yml", choices = c(r$index$path, yml$path))
  })

  observeEvent(input$select_yml, {

    selected$yml <- input$select_yml
    output$ymlui <- renderUI({
      tagList(
        tags$style(HTML("pre {border: none}")),
        tags$div(
          id = ns("editable"),
          contenteditable = "true",
          style = "background-color: #f5f5f5; border: 1px solid #ccc;",
          verbatimTextOutput(ns("outyml"))
        ),
        tags$br(),
        #actionButton(ns("save"), "Save"),
        tags$br(),

        tags$script(paste0('
           document.getElementById("', ns("save"), '").onclick = function() {
            var x = document.getElementById("', ns("editable"), '").textContent;
            Shiny.onInputChange("', ns("fromjs"), '", x);
                              };'))
      )
    })
    output$outyml <- renderPrint({
      as_glue(readLines(
        input$select_yml
      ))
    })
    yml$path <- list.files(r$path, pattern = "yml$", full.names = TRUE)
  })

  observeEvent(input$fromjs, {
    write(input$fromjs, selected$yml)
    saved()
  })
}
