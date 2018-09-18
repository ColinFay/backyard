#' @importFrom shiny NS tagList column h2 selectInput uiOutput tags actionButton
mod_any_fileui <- function(id){
  ns <- NS(id)
  tagList(
    column(
      12,
      h2("Edit Options"),
      selectInput(ns("select_file"), label = "Select the file to edit", choices = letters, width = "100%"),
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
#' @importFrom shiny reactiveValues observeEvent req updateSelectInput renderUI tagList tags HTML verbatimTextOutput
mod_any_file <- function(input, output, session, r){
  ns <- session$ns
  selected <- reactiveValues(yml = NULL)


  observeEvent(r$index$path, {
    req(r$index$path)
    updateSelectInput(session, "select_file", choices = list.files(r$path, full.names = TRUE))
  })

  observeEvent(input$select_file, {

    selected$file <- input$select_file
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
        input$select_file
      ))
    })
  })

  observeEvent(input$fromjs, {
    write(input$fromjs, selected$file)
    saved()
  })
  }
