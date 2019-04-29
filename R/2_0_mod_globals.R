#' @importFrom shiny NS tagList tabsetPanel tabPanel
#' @include 2_1_mod_globaloptions.R 2_2_mod_bookdown_options.R 2_3_mod_output_options.R 2_4_mod_manually.R 2_5_mod_file.R
mod_globalsui <- function(id){
  ns <- NS(id)
  tagList(
    tabsetPanel(
      tabPanel(id = ns("global"), "Global", mod_global_optionsui( ns("mod_global_optionsui"))),
      #tabPanel(id = ns("bookdown"), "Bookdown", mod_bookdown_optionsui(ns("mod_bookdown_optionsui"))),
      #tabPanel(id = ns("output"), "Output", mod_output_optionsui( ns("mod_output_optionsui") )),
      tabPanel(id = ns("manually"), "Edit options manually", mod_yml_manuallyui( ns("mod_yml_manuallyui") )),
      tabPanel(id = ns("files"), "Edit files manually", mod_any_fileui( ns("mod_any_fileui") ))
    )
  )
}

#' @importFrom shiny callModule
mod_globals <- function(input, output, session, r){
  ns <- session$ns

  callModule(mod_global_options, "mod_global_optionsui", r)
  #callModule(mod_bookdown_options, "mod_bookdown_optionsui", r)
  #callModule(mod_output_options, "mod_output_optionsui", r)
  callModule(mod_yml_manually, "mod_yml_manuallyui", r)
  callModule(mod_any_file, "mod_any_fileui", r)

}
