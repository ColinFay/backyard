#' @importFrom shiny NS tagList navbarPage tabPanel tags
#' @importFrom shinyalert useShinyalert
mod_home_pageui <- function(id, path){
  ns <- NS(id)
  index_book <- paste0("file://", file.path(path, "_book", "index.html"))
  tagList(
    useShinyalert(),
    navbarPage("backyard", id = ns("plop"),
               tabPanel("About", mod_aboutui(ns("mod_aboutui"))),
               tabPanel("Chapters", mod_chapterui(ns("mod_chapterui"))),
               tabPanel("Options", mod_globalsui(ns("mod_globalsui"))),
               #tabPanel("Output options", mod_output_optionsui(ns("mod_output_optionsui"))),
               tabPanel("Design", mod_designui(ns("mod_designui"))),
               tabPanel("Render", mod_renderui(ns("mod_renderui"))),
               tags$script(
               paste0('$( document ).ready(function() {
               var ul = document.getElementById("',ns("plop"),'");
               li = document.createElement("li");
               var button = document.createElement("text");
               button.innerHTML = "Preview Book";
               li.appendChild(button);
               li.setAttribute("id","',ns("buttonpreview"),'");
               li.setAttribute("type","button");
               li.setAttribute("class","btn btn-default action-button");
               li.setAttribute("style","margin-top: 0.5em;");
               ul.appendChild(li);
               document.getElementById("',ns("buttonpreview"),'").onclick = function() {Shiny.onInputChange("',ns("preview"),'", Math.random());};
                });'))
    )
  )
}

#' @importFrom bookdown render_book
#' @importFrom shiny callModule observeEvent withProgress
#' @importFrom utils browseURL
#' @importFrom withr with_dir
mod_home_page <- function(input, output, session, r){
  ns <- session$ns

  callModule(mod_about, "mod_aboutui", r = r)
  callModule(mod_globals, "mod_globalsui", r = r)
  callModule(mod_output_options, "mod_output_optionsui", r = r)
  callModule(mod_chapter, "mod_chapterui", r = r)
  callModule(mod_design, "mod_designui", r = r)
  callModule(mod_render, "mod_renderui", r = r)

  observeEvent(input$preview, {
    withProgress(
      message = "Rendering the preview", {
      t <- tempdir()
      with_dir(r$path, {
        where <- render_book(input =  r$path, output_dir = t)
      })
      browseURL(where)
    })

  })
}
