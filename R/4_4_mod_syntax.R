#' @importFrom shiny NS tagList column h2 radioButtons actionButton
mod_syntaxui <- function(id){
  ns <- NS(id)
  tagList(
    column(6,
           h2("Select a Syntax highlighting:"),
           radioButtons(ns("syntax_high"), "Type",
                        choices = c("default", "tango", "pygments", "kate","monochrome",
                                    "espresso", "zenburn", "haddock")),
           actionButton(ns("save_h"), "Save")
    )#,
    # column(6,
    #        h2("Select a HTML book theme:"),
    #        radioButtons(
    #          ns("html_themes"),
    #          "html themes:",
    #          choices = c("default", "cerulean", "journal", "flatly", "darkly", "readable","spacelab",
    #                      "united","cosmo", "lumen","paper","sandstone","simplex","yeti", "null")
    #        ),
    #        actionButton(ns("save_t"), "Save")
    #        )
  )
}

#' @importFrom bookdown gitbook html_book
#' @importFrom shiny observeEvent
#' @importFrom yaml write_yaml
mod_syntax <- function(input, output, session, r){
  ns <- session$ns

  observeEvent(input$save_h, {
    r$output_yml$`gitbook`$highlight <- input$syntax_high
    write_yaml(r$output_yml, r$path %/% "_output.yml" )
    saved()
  })
  observeEvent(input$save_t, {
    #browser()
    r$output_yml$`html_book`$theme <- input$html_themes
    write_yaml(r$output_yml, r$path %/% "_output.yml" )
    saved()
  })
}
