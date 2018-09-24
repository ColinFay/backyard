#' @importFrom shiny NS tagList column h2 textInput textAreaInput h3 actionButton tags
mod_global_optionsui <- function(id){
  ns <- NS(id)
  tagList(
    column(4,
           h2("Global options:"),
           textInput(ns("title"), "Book title", value = ""),
           textInput(ns("author"), "Book author", value = ""),
           #textInput(ns("date"), "Book date", value = ""),
           textAreaInput(ns("description"), "Book description", value = "", rows = 6)
    ),
    column(4,
           h3("Config"),
           textAreaInput(ns("before"), "Toc - before"),
           textAreaInput(ns("after"), "Toc - after")),
    # column(4,
    #        textInput(ns("site"), "Book site", value = ""),
    #        textInput(ns("documentclass"), "Book Class", value = ""),
    #        textInput(ns("bibliography"), "Book bibliography", value = ""),
    #        textInput(ns("biblio-style"), "Book biblio-style", value = ""),
    #        textInput(ns("link-citations"), "Book link-citations", value = "")
    #        ),
    # column(4,
    #        textInput(ns("site"), "Book site", value = ""),
    #        textInput(ns("documentclass"), "Book Class", value = ""),
    #        textInput(ns("bibliography"), "Book bibliography", value = ""),
    #        textInput(ns("biblio-style"), "Book biblio-style", value = ""),
    #        textInput(ns("link-citations"), "Book link-citations", value = "")
    #        ),
    column(12,
           h3("Save options"),
           actionButton(ns("save"), "Save"),
           tags$br()
           )
  )
}

#' @importFrom bookdown gitbook
#' @importFrom shiny observeEvent req updateTextInput updateTextAreaInput
#' @importFrom yaml as.yaml write_yaml
mod_global_options <- function(input, output, session, r){
  ns <- session$ns
  observeEvent(r$index_yml, {
    req(r$index_yml)
    updateTextInput(session, "title", value = r$index_yml$title %||% "")
    updateTextInput(session, "author", value = r$index_yml$author %||% "")
    updateTextAreaInput(session, "description", value = r$index_yml$description %||% "")
    updateTextInput(session, "before", value = r$output_yml$`bookdown::gitbook`$config$toc$before %||% "")
    updateTextInput(session, "after", value = r$output_yml$`bookdown::gitbook`$config$toc$after %||% "")
  })

  observeEvent(input$save, {
    r$index_yml$title <- input$title
    r$index_yml$author <- input$author
    r$index_yml$date <- input$date
    r$index_yml$description <- input$description
    write(
      c("---\n", as.yaml(r$index_yml), "\n---\n\n", r$index$content),
      r$index$path
    )
    r$output_yml$`bookdown::gitbook`$config$toc$before <- input$before
    r$output_yml$`bookdown::gitbook`$config$toc$after <- input$after
    write_yaml(r$output_yml, r$path %/% "_output.yml")
    saved()
  })
}

