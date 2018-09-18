#' @importFrom shiny NS tagList uiOutput
mod_aboutui <- function(id){
  ns <- NS(id)
  tagList(
    uiOutput(ns("script"))
  )
}

#' @importFrom glue glue
#' @importFrom shiny observe renderUI req tagList h2 column h3 tags
mod_about <- function(input, output, session, r){
  ns <- session$ns

  observe({
    output$script <- renderUI({
      req(r$chapters)
      tagList(
        h2(glue("Book: {r$index_yml$title}")),
        column(6,
               h3(glue("{length(r$chapters)} chapters found:")),
               list_to_li(basename(as.character(r$chapters)))),
        column(6,
               h3("About the book:"),
               info_to_li(r$index_yml)),
        tags$hr(),
        tags$hr(),
        tags$hr(),
        column(6,
               h3("Bookdown:"),
               info_to_li(
                 c(
                   "Website:" = "https://bookdown.org/yihui/bookdown/",
                   "GitHub:" = "https://github.com/rstudio/bookdown"
                 )
               ),
               h3("Backyard:"),
               info_to_li(
                 c(
                   "GitHub:" = "https://github.com/ColinFay/backyard",
                   "Issues:" = "https://github.com/ColinFay/backyard/issues"
                 )
               )
               ),
        tags$br()
      )
    })
  })

}
