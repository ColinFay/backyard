#' @importFrom shiny NS tagList h2 column textInput selectInput tags verbatimTextOutput actionButton h3
mod_bookdown_optionsui <- function(id) {
  ns <- NS(id)
  tagList(
    h2("Bookdown options:"),
    column(
      4,
      textInput(ns("book_filename"), "book_filename"),
      selectInput(ns("delete_merged_file"), "delete_merged_file", c("true", "false"), selected = NULL),
      textInput(ns("before_chapter_script"), "before_chapter_script"),
      textInput(ns("after_chapter_script"), "after_chapter_script"),
      textInput(ns("edit"), "edit")
    ),
    column(
      4,
      textInput(ns("rmd_subdir"), "rmd_subdir"),
      textInput(ns("output_dir"), "output_dir"),
      textInput(ns("clean"), "clean"),
      selectInput(ns("new_session"), "new_session", choices = c(TRUE, FALSE), selected = NULL)

    ),
    column(
      4,
      tags$div(
        id = ns("editable"),
        contenteditable="true",
        style = "background-color: #f5f5f5; border: 1px solid #ccc;",
        verbatimTextOutput(ns("out"))
      ),
      tags$br(),
      actionButton(ns("savelgg"), "Save Language"),

      tags$script(paste0('
      document.getElementById("', ns("save"), '").onclick = function() {
      var x = document.getElementById("', ns("out"), '").textContent;
      Shiny.onInputChange("', ns("fromjs"), '", x);
    };'))
    ),
    column(12,
           h3("Save Bookdown option"),
           actionButton(ns("save"), "Save"),
           tags$br())
  )
}

#' @importFrom glue as_glue
#' @importFrom shiny observeEvent renderPrint
#' @importFrom yaml write_yaml
mod_bookdown_options <- function(input, output, session, r) {
  ns <- session$ns

  observeEvent(r$path, {
    yaml_bkdwn <- r$bookdown_yml
    yaml_bkdwn$language <- NULL
    yaml_bkdwn$rmd_files <-  NULL

    yaml_bkdwn <- dropNulls(yaml_bkdwn)

    mapply(function(x, y) {
      session$sendInputMessage(y, list(value = x))
    }, yaml_bkdwn, names(yaml_bkdwn))

  })

  output$out <- renderPrint({
    as_glue(readLines(system.file("language", package = "backdown")))
  })
  observeEvent(input$fromjs, {
    write(input$fromjs, rmd)
    saved()
  })

  observeEvent(input$save, {
    r$bookdown_yml$book_filename <- input$book_filename
    r$bookdown_yml$delete_merged_file <- input$delete_merged_file
    r$bookdown_yml$before_chapter_script <- input$before_chapter_script
    r$bookdown_yml$after_chapter_script <- input$after_chapter_script
    r$bookdown_yml$edit <- input$edit
    r$bookdown_yml$rmd_subdir <- input$rmd_subdir
    r$bookdown_yml$output_dir <- input$output_dir
    r$bookdown_yml$clean <- input$clean
    r$bookdown_yml <- drop_empty(r$bookdown_yml)
    write_yaml(r$bookdown_yml, file =  r$path %/% "_bookdown.yml" )
    saved()
  })

}
