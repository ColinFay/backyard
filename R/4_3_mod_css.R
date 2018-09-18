mod_cssui <- function(id) {
  ns <- NS(id)
  tagList(
    column(
      7,
      h2("Edit CSS"),
      radioButtons(ns("select_css"), label = "Select the CSS file to edit", choices = letters),
      uiOutput(ns("cssui"))
    ),
    column(
      5,

      h2("Add a CSS file"),
      textInput(ns("newcss"), "Name (without .css)"),
      actionButton(ns("go"), "Create"),
      tags$br(),
      h2("Delete a CSS file"),
      radioButtons(ns("to_delete"), label = "Select the CSS file to delete", choices = letters),
      actionButton(ns("delete"), "Delete")
    )
  )
}

mod_css <- function(input, output, session, r) {
  ns <- session$ns

  selected <- reactiveValues(css = NULL)
  #browser()
  css <- reactiveValues(
    path = list.files(r$path, pattern = "css$", full.names = TRUE, include.dirs = FALSE, recursive = FALSE)
  )

  observe({
    updateRadioButtons(session, "select_css", choices = css$path)
    updateRadioButtons(session, "to_delete", choices = css$path)
  })

  observeEvent(input$select_css, {

    selected$css <- input$select_css
    output$cssui <- renderUI({
      tagList(
        tags$style(HTML("pre {border: none}")),
        tags$div(
          id = ns("editable"),
          contenteditable = "true",
          style = "background-color: #f5f5f5; border: 1px solid #ccc;",
          verbatimTextOutput(ns("outcss"))
        ),
        tags$br(),
        actionButton(ns("save"), "Save"),
        tags$br(),

        tags$script(paste0('
           document.getElementById("', ns("save"), '").onclick = function() {
            var x = document.getElementById("', ns("editable"), '").textContent;
            Shiny.onInputChange("', ns("fromjs"), '", x);
                              };'))
      )
    })
    output$outcss <- renderPrint({
      as_glue(readLines(
        input$select_css
      ))
    })
    css$path <- list.files(r$path, pattern = "css$", full.names = TRUE)
  })


  observeEvent(input$fromjs, {
    write(input$fromjs, selected$css)
    write("\n", selected$css, append = TRUE)
    saved()
  })

  observeEvent(input$go, {
    new_css <- r$path %/% glue("{input$newcss}.css")
    if (file.exists(new_css)) {
      shinyalert(
        "This CSS file already exists",
        type = "error"
      )
      return(NULL)
    }
    file.create(new_css)
    write("\n\n", new_css)
    saved()
    css$path <- list.files(r$path, pattern = "css$", full.names = TRUE)
  })

  observeEvent(input$delete, {
    unlink(input$to_delete)
    saved()
    css$path <- list.files(r$path, pattern = "css$", full.names = TRUE)
  })
}
