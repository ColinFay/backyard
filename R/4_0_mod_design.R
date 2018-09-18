#' @importFrom shiny NS tabsetPanel tabPanel
mod_designui <- function(id){
  ns <- NS(id)
  tabsetPanel(
    #tabPanel(id = ns("include"), "Include", mod_includeui( ns("mod_include") ) ),
    tabPanel(id = ns("css"), "CSS", mod_cssui( ns("mod_cssui") ) ),
    tabPanel(id = ns("syntax"), "Highlight", mod_syntaxui( ns("mod_syntaxui") ) )#,
    #tabPanel(id = ns("theme"), "Themes", mod_themingui(ns("mod_themingui")))
    )
}

#' @importFrom shiny callModule
mod_design <- function(input, output, session, r){
  ns <- session$ns
  callModule(mod_include, "mod_includeui", r)
  callModule(mod_css, "mod_cssui", r)
  callModule(mod_syntax, "mod_syntaxui", r)
  #callModule(mod_theming, "mod_themingui", r)

}
