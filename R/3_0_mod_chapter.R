#' @importFrom shiny NS tabsetPanel tabPanel column radioButtons actionButton uiOutput h3 textInput selectInput
mod_chapterui <- function(id){
  ns <- NS(id)
  tabsetPanel(
    tabPanel(
      "Chapter edit",
      column(4,
             radioButtons(ns("choices"),"chapters",choices = letters),
             actionButton(ns("interactive"), "Update interactively"),
             actionButton(ns("markdown"), "Update as Markdown")
             ),

      column(8, uiOutput(ns("edit")),
             actionButton(ns("saveeditedcontent"), "Save", style = "margin-bottom: 1em;"),
             tags$br())
    ),
    tabPanel(
      "Manage Chapters",
      column(4,
             h3("Add a new chapter"),
             textInput(ns("new_chapter"), "Title (without .Rmd)"),
             actionButton(ns("add_chapter"), "Add")),
      column(4,
             h3("Delete a chapter"),
             selectInput(ns("delete_list"), "Chapters", choices = letters),
             actionButton(ns("delete_chapter"), "Delete")
             ),
      column(4,
             h3("Rename a chapter"),
             selectInput(ns("rename_list"), "Chapters", choices = letters),
             textInput(ns("rename_name"), "New name (without .Rmd)"),
             actionButton(ns("rename_chapter"), "Rename")
             )
    ),
    tabPanel(
      "Reorder Chapter",
      mod_reorderui(ns("mod_reorderui"))
    )
  )
}

#' @importFrom shiny callModule reactiveValues observe req updateRadioButtons updateSelectInput observeEvent renderUI
mod_chapter <- function(input, output, session, r){
  ns <- session$ns
  r$go <- 0
  callModule(mod_reorder, "mod_reorderui", r)

  chap <- reactiveValues(chap =  NULL)

  observe({
    req(r$chapters)
    updateRadioButtons(session, "choices",
                       choices = basename(as.character(r$chapters)))
    updateSelectInput(session, "delete_list",
                      choices = basename(as.character(r$chapters)))
    updateSelectInput(session, "rename_list",
                      choices = basename(as.character(r$chapters)))
  })

  lequel <- reactive({grep(input$choices, r$chapters, value = TRUE)})

  observeEvent(input$choices, {
    chap$chap <- grep(input$choices, r$chapters, value = TRUE)
    output$edit <- renderUI({
      quill_rmdui(ns("quill_rmdui"))
    })
    callModule(quill_rmd, "quill_rmdui", chap$chap, r, ns)
  })

  observeEvent(input$interactive, {
    chap$chap <- grep(input$choices, r$chapters, value = TRUE)
    output$edit <- renderUI({
      quill_rmdui(ns("quill_rmdui"))
    })
    callModule(quill_rmd, "quill_rmdui", chap$chap, r, ns)
  })

  observeEvent(input$markdown, {
    chap$chap <- grep(input$choices, r$chapters, value = TRUE)
    output$edit <- renderUI({
      mod_editable_rmdui(id = ns("mod_editable_rmdui"), parentns = ns)
    })
    callModule(mod_editable_rmd, "mod_editable_rmdui", chap$chap, r)

  }, ignoreInit = TRUE)

  observeEvent(input$saveeditedcontent, {
    cat(crayon::red(input$saveeditedcontent), "\n")
    lequel <- grep(input$choices, r$chapters, value = TRUE)
    if (input$saveeditedcontent != 0) {
      if (basename(input$choices) == basename(r$index$path)) {
        r$index$content <- html_to_markdown(HTML(input$editedfromjs))
        write("---", lequel)
        write(as.yaml(r$index_yml), lequel, append = TRUE)
        write("---", lequel, append = TRUE)
        write(r$index$content, lequel, append = TRUE)
      } else {
        write(html_to_markdown(HTML(input$editedfromjs)), lequel)
      }



    shinyalert("Done!", type = "success")
    }

  })

  shiny::observeEvent(input$fromjsmd, {
    r$index$content <- input$fromjsmd
    lequel <- grep(input$choices, r$chapters, value = TRUE)

    if (basename(lequel) == basename(r$index$path)){
      write("---", lequel)
      write(as.yaml(r$index_yml), lequel, append = TRUE)
      write("---", lequel, append = TRUE)
      write(r$index$content, lequel, append = TRUE)
    } else {
      write(r$index$content, lequel)
    }
    saved()
  })

  observeEvent(input$add_chapter, {
    new_chapter <- r$path %/% paste0(input$new_chapter, ".Rmd")
    file.create(new_chapter)
    write("\n\n## A new chapter", new_chapter)
    r$chapters <- factor(
      c(as.character(r$chapters), new_chapter),
      levels = c(as.character(r$chapters), new_chapter)
    )
    saved()
  }, ignoreInit = TRUE)

  observeEvent(input$delete_chapter, {
    to_delete <- which(grepl(input$delete_list, r$chapters))
    unlink(r$chapters[to_delete])
    r$chapters <- r$chapters[-to_delete]
    saved()
  }, ignoreInit = TRUE)

  observeEvent(input$rename_chapter, {
    #browser()
    to_rename <- which(grepl(input$rename_list, r$chapters))
    new_name <- r$path %/% paste0(input$rename_name, ".Rmd")
    file.rename(file.path(r$chapters[to_rename]), file.path(new_name))
    levels(r$chapters)[to_rename]  <- new_name
    r$chapters[to_rename] <- new_name
  }, ignoreInit = TRUE)



}

