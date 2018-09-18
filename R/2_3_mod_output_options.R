#' @importFrom shiny NS tagList column h2 h3 textInput textAreaInput actionButton
mod_output_optionsui <- function(id){
  ns <- NS(id)
  tagList(
    column(3,
           h2("gitbook"),
           h3("Global"),
           textInput(ns("css"), "css"),
           textInput(ns("lib_dir"), "lib_dir"),
           textInput(ns("split_by"), "split_by")),
    column(3,
           h3("Config"),
           textAreaInput(ns("before"), "Toc - before"),
           textAreaInput(ns("after"), "Toc - after"),
           textInput(ns("position"), "toolbar position"),
           textInput(ns("html_download"), "Download")),
    column(12, actionButton(ns("save"), "Save '_output.yml'"))
  )
}

#' @importFrom bookdown gitbook
#' @importFrom shiny observe req updateTextInput observeEvent
#' @importFrom yaml write_yaml
mod_output_options <- function(input, output, session, r){
  ns <- session$ns
  observe({
    req(r$path)
    updateTextInput(session, "css", value = r$output_yml$`gitbook`$css)
    updateTextInput(session, "lib_dir", value = r$output_yml$`gitbook`$lib_dir)
    updateTextInput(session, "split_by", value = r$output_yml$`gitbook`$split_by)
    updateTextInput(session, "before", value = r$output_yml$`gitbook`$config$toc$before)
    updateTextInput(session, "after", value = r$output_yml$`gitbook`$config$toc$after)
    updateTextInput(session, "download", value = r$output_yml$`gitbook`$config$download)
    updateTextInput(session, "position", value = r$output_yml$`gitbook`$config$toolbar$position)
  })

  observeEvent(input$save, {
    r$output_yml$`gitbook`$css <- input$css
    r$output_yml$`gitbook`$lib_dir <- input$lib_dir
    r$output_yml$`gitbook`$split_by <- input$split_by
    r$output_yml$`gitbook`$config$toc$before <- input$before
    r$output_yml$`gitbook`$config$toc$after <- input$edit
    r$output_yml$`gitbook`$config$download <- input$download
    r$output_yml$`gitbook`$config$toolbar$position <- input$position
    r$bookdown_yml <- drop_empty(r$bookdown_yml)
    write_yaml(r$bookdown_yml, file =  r$path %/% "_bookdown.yml" )
    saved()
  })

}

