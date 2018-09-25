#' @importFrom shiny NS tagList includeScript column uiOutput
mod_reorderui <- function(id){
  ns <- NS(id)
  tagList(
    # includeScript(system.file("html5sortable/jquery.sortable.js", package = "backyard")),
    # column(2,
    #        uiOutput(ns("chapterlist_sortable"))
    #        ),
    # column(2,
    #        uiOutput(ns("chapterlist"))
    #        )

  )
}

#' @importFrom shiny renderUI tagList tags actionButton HTML observeEvent
#' @importFrom yaml write_yaml
mod_reorder <- function(input, output, session, r){
  ns <- session$ns
  output$chapterlist_sortable <- renderUI({
    tagList(
      tags$ul( class="sortable",
               list_to_p(basename(as.character(r$chapters)), class = "sortable-list")
      ),
      tags$br(),
      tags$div(align = "center",
               actionButton(ns("save"), "Save")),
      tags$br(),
      tags$script("$('.sortable').sortable();"),
      tags$script(HTML(paste0('
      document.getElementById("', ns("save"), '").onclick = function() {
      var val = document.getElementsByClassName("sortable-list");
      var l = [];
      for (var i = 0; i < val.length; i++) {
        l.push(val[i].innerText)
      };
      Shiny.onInputChange("', ns("fromjs"), '", l);
    };')))
    )

  })

  observe({
    output$chapterlist <- renderUI({

      tagList(
        tags$h3("Current order:"),
        tags$ul(list_to_p(basename(as.character(r$chapters)))
        )

      )
  })
  })

  observeEvent(input$fromjs, {
    new_order <- lapply(input$fromjs,
           function(x){
             grep(x, r$chapters, value = TRUE)
           })
    levels(r$chapters) <- as.character(new_order)
    r$bookdown_yml$rmd_files <- r$chapters
    write_yaml(
      r$bookdown_yml,
      paste0(r$path, "/_bookdown.yml")
      )
    saved()
  })

}

# library(shiny)
#
# ui <- fluidPage(
#   mod_reorderui("test")
# )
#
# server <- function(input, output, session){
#   callModule(mod_reorder, "test")
# }
#
# shinyApp(ui, server)
