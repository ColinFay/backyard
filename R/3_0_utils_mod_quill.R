#' @importFrom shiny NS tagList uiOutput
quill_rmdui <- function(id) {
  ns <- NS(id)
  tagList(
    uiOutput(ns("plop"))
  )
}

#' @importFrom shiny renderUI tagList includeScript tags actionButton icon includeMarkdown observeEvent HTML
#' @importFrom tools file_path_sans_ext
#' @importFrom yaml as.yaml
quill_rmd <- function(input, output, session, rmd, r) {
  ns <- session$ns
  id <- file_path_sans_ext(basename(rmd))
  output$plop <- renderUI({
    if (basename(rmd) == basename(r$index$path)) {
      tf <- tempfile(fileext = ".Rmd")
      write(r$index$content, tf)
      rmd <- tf
    }
    tagList(
      includeScript(system.file("www/code.js", package = "backyard")),
      tags$div(id = "wholetoolbar",
               tags$div(
        align = "center",
        class = "toolbar",
        tags$span(
          class = "inside",
          actionButton(inputId = "undo", label = NULL, icon = icon("undo"), "data-command" = "undo", "data-tooltip" = "Undo changes"),
          actionButton(inputId = "redo", label = NULL, icon = icon("repeat"), "data-command" = "redo", "data-tooltip" = "Redo changes")
        ),
        tags$span(
          class = "inside",
          actionButton(inputId = "bold", label = NULL, icon = icon("bold"), "data-command" = "bold", "data-tooltip" = "Bold"),
          actionButton(inputId = "italic", label = NULL, icon = icon("italic"), "data-command" = "italic", "data-tooltip" = "Italics"),
          actionButton(inputId = "underline", label = NULL, icon = icon("underline"), "data-command" = "underline", "data-tooltip" = "Underline"),
          actionButton(inputId = "strikeThrough", label = NULL, icon = icon("strikethrough"), "data-command" = "strikeThrough", "data-tooltip" = "Strike")
        ),
        tags$span(
          class = "inside",
          actionButton(inputId = "indent", label = NULL, icon = icon("indent"), "data-command" = "indent", "data-tooltip" = "Indent"),
          actionButton(inputId = "outdent", label = NULL, icon = icon("outdent"), "data-command" = "outdent", "data-tooltip" = "Outdent"),
          actionButton(inputId = "justifyLeft", label = NULL, icon = icon("align-left"), "data-command" = "justifyLeft", "data-tooltip" = "justify Left"),
          actionButton(inputId = "justifyCenter", label = NULL, icon = icon("align-center"), "data-command" = "justifyCenter", "data-tooltip" = "Center"),
          actionButton(inputId = "justifyRight", label = NULL, icon = icon("align-right"), "data-command" = "justifyRight", "data-tooltip" = "justify Right")
        ),
        tags$span(
          class = "inside",
          actionButton(inputId = "insertUnorderedList", label = NULL, icon = icon("list-ul"), "data-command" = "insertUnorderedList", "data-tooltip" = "Insert an unordered list"),
          actionButton(inputId = "insertOrderedList", label = NULL, icon = icon("list-ol"), "data-command" = "insertOrderedList", "data-tooltip" = "Insert an ordered list")
        ),
        tags$div(
          align = "center",
          class = "toolbar",
          tags$span(
            class = "inside",
            actionButton(inputId = "h1", label = "h1", "data-command" = "h1", "data-tooltip" = "H1"),
            actionButton(inputId = "h2", label = "h2", "data-command" = "h2", "data-tooltip" = "H2"),
            actionButton(inputId = "h3", label = "h3", "data-command" = "h3", "data-tooltip" = "H3"),
            actionButton(inputId = "h4", label = "h4", "data-command" = "h4", "data-tooltip" = "H4"),
            actionButton(inputId = "h5", label = "h5", "data-command" = "h5", "data-tooltip" = "H5"),
            actionButton(inputId = "h6", label = "h6", "data-command" = "h6", "data-tooltip" = "H6")
          ),
          tags$span(
            class = "inside",
            actionButton(inputId = "createlink", label = NULL, icon = icon("link"), "data-command" = "createlink", "data-tooltip" = "Create a link"),
            actionButton(inputId = "unlink", label = NULL, icon = icon("unlink"), "data-command" = "unlink", "data-tooltip" = "Remove link"),
            actionButton(inputId = "insertimage", label = NULL, icon = icon("image"), "data-command" = "insertimage", "data-tooltip" = "Insert an image"),
            actionButton(inputId = "blockquote", label = NULL, icon = icon("quote-left"), "data-command" = "blockquote", "data-tooltip" = "Quote"),
            actionButton(inputId = "pre", label = NULL, icon = icon("code"), "data-command" = "pre", "data-tooltip" = "Code"),
            actionButton(inputId = "p", label = NULL, icon = icon("paragraph"), "data-command" = "p", "data-tooltip" = "New paragraph"),
            actionButton(inputId = "superscript", label = NULL, icon = icon("superscript"), "data-command" = "superscript", "data-tooltip" = "Superscript"),
            actionButton(inputId = "subscript", label = NULL, icon = icon("subscript"), "data-command" = "subscript", "data-tooltip" = "Subscript"),
            actionButton(inputId = "insertHorizontalRule", label = NULL, icon = icon("window-minimize"), "data-command" = "insertHorizontalRule", "data-tooltip" = "Insert an horizontal bar")
          ),
          tags$span(
            class = "inside",
            actionButton(inputId = "removeFormat", label = NULL, icon = icon("eraser"), "data-command" = "removeFormat", "data-tooltip" = "Remove all styles")
          )
        )
      )),
      tags$br(),
      tags$div(
        id = ns(id),
        class = "contenteditablemd",
        contenteditable = "true",
        includeMarkdown(rmd)
      ),
      # enquill(ns(id)),
      tags$br(),
      actionButton(ns("save"), "Save", style = "margin-bottom: 1em;"),
      tags$br(),
      tags$script(paste0('
      document.getElementById("', ns("save"), '").onclick = function() {
      var x = document.getElementById("', ns(id), '").innerHTML;
      Shiny.onInputChange("', ns("fromjs"), '", x);
    };'))
    )
  })

  observeEvent(input$fromjs, {
    res <- html_to_markdown(HTML(input$fromjs))

    if (basename(rmd) == basename(r$index$path)) {
      r$index$content <- res
      res <- paste0("---", as.yaml(r$index_yml), "---", res)
    }

    write(res, rmd)

    saved()
  })
}
