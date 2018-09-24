#' @import shiny
#' @importFrom graphics hist
#' @importFrom stats rnorm
#' @importFrom yaml yaml.load
#'
#' @importFrom bookdown gitbook pdf_book html_book epub_book
#' @importFrom shiny reactiveValues observeEvent observe showModal isTruthy removeModal req renderUI callModule
#' @importFrom shinyFiles shinyFileChoose shinyDirChoose parseFilePaths parseDirPath
#' @importFrom utils getFromNamespace
app_server <- function(input, output, session) {
  r <- reactiveValues(
    path = NULL,
    exists = FALSE,
    index = list(
      path = NULL,
      content = NULL
    ),
    index_yml = list(
      content = NULL
    ),
    chapters = NULL,
    bookdown_yml = list(
      path = NULL,
      content = NULL,
      order = NULL
    ),
    output_yml = list(
      path = NULL,
      content = list(
        `bookdown::gitbook` = list(
          css = NA,
          config = list(
            toc = list(
              before = NA,
              after = NA
            ),
            download = NA
          )
        ),
        `bookdown::pdf_book` = list(
          includes = list(
            in_header = NA
          ),
          latex_engine = NA,
          citation_package = NA,
          keep_tex = TRUE
        ),
        `bookdown::html_book` = list(
          css = NA
        ),
        `bookdown::epub_book` = list(
          css = NA
        )
      )
    ),
    book_bib = NULL,
    package_bib = NULL,
    style = NULL
  )
  observeEvent(TRUE, {
    r$index$path <- getOption("bkyrd")
  }, once = TRUE)

  observeEvent(TRUE, {
    #browser()
    r$safe_mode <- getOption("bkyrdsafe")
    if (r$safe_mode & ! is.na(r$index$path)){
      path <- dirname(r$index$path)
      safe_dir <- glue("{dirname(path)}/backyard_copy")
      dir.create(safe_dir, showWarnings = FALSE)
      file.copy(from = path, safe_dir, recursive = TRUE)
    }
  }, once = TRUE)

  observeEvent(r$index$path, {
    if (is.na(r$index$path)) {
      showModal(opening())
    }
  })

  roots <- c(wd = getOption("bkyrdhome"))
  shinyFileChoose(
    input,
    "files",
    roots = roots
  )

  shinyDirChoose(
    input,
    "dir",
    roots = roots
  )

  observeEvent(input$ok, {
    if ( ! isTruthy(input$files) & ! isTruthy(input$dir) ) {
      showModal(opening(failed = TRUE))
      return(NULL)
    }

    if (isTruthy(input$dir)) {
      if ( dir.exists(normalizePath(parseDirPath(roots, input$dir)) %/% input$namedir) ) {
        showModal(opening(exists = TRUE))
        return(NULL)
      }
    }

    if (isTruthy(input$files) & isTruthy(input$dir)) {
      showModal(opening(both = TRUE))
      return(NULL)
    }

    if (isTruthy(input$files) & ! isTruthy(input$dir) ) {
      res <- parseFilePaths(roots, input$files)
      if (file.exists(res$datapath)) {
        options("bkyrd" = res$datapath)
        r$index$path <- res$datapath

        if (r$safe_mode){
          path <- dirname(r$index$path)
          safe_dir <- glue("{dirname(path)}/backyard_copy")
          dir.create(safe_dir, showWarnings = FALSE)
          file.copy(from = path, safe_dir, recursive = TRUE)
        }
        r$path <- normalizePath(dirname(r$index$path))
        removeModal()
      } else {
        showModal(opening(failed = TRUE))
      }
    } else if ( !isTruthy(input$files) & isTruthy(input$dir) ) {

      r$path <- normalizePath(parseDirPath(roots, input$dir))
      if (dir.exists(r$path)){
        showModal(opening(exists = TRUE))
      }
      r$path <- file.path(r$path, input$namedir)
      r$index$path <- r$path %/% "index.Rmd"
      dir.create(r$path)
      getFromNamespace("bookdown_skeleton", "bookdown")(r$path)
      file.create(r$path %/% "book.bib")
      file.create(r$path %/% "package.bib")
      if (r$safe_mode){
        path <- dirname(r$index$path)
        safe_dir <- glue("{dirname(path)}/backyard_copy")
        dir.create(safe_dir, showWarnings = FALSE)
        file.copy(from = path, safe_dir, recursive = TRUE)
      }
      #browser()
      removeModal()
    } else {
      showModal(opening(failed = TRUE))
    }
  })

  observeEvent(input$cancel, {
    showModal(opening(failed = TRUE))
  })

  observeEvent(r$index$path, {

    req(r$index$path)
    r$exists <- TRUE
    if (is.null(r$path)){
      r$path <- dirname(r$index$path)
    }

    index_yml <- readLines(r$index$path)
    idx <- grep("---", index_yml)
    idx1 <- idx[1] + 1
    idx2 <- idx[2] - 1
    r$index_yml <- yaml.load(index_yml[idx1:idx2])
    r$index$content <- index_yml[(idx2+2):length(index_yml)]


    if ( file.exists( r$path %/% "_bookdown.yml" ) ) {
      r$bookdown_yml <- yaml.load(readLines(r$path %/% "_bookdown.yml"))
    } else {
      file.copy(
        system.file("_bookdown.yml", package = "backyard"),
        r$path %/% "_bookdown.yml"
      )
      r$bookdown_yml <- yaml.load(readLines(r$path %/% "_bookdown.yml"))
    }
    if ( is.null(r$bookdown_yml$rmd_files) ){
      rmds <- list.files(r$path, pattern = "Rmd$", full.names = TRUE)
      index_indx <- which(grepl(basename(r$index$path),rmds))
      rmds <- rmds[-index_indx]
      r$chapters <- factor( c(r$index$path, rmds) , levels = c(r$index$path, rmds) )
    } else {
      r$chapters <- paste0(r$path, "/", basename(r$bookdown_yml$rmd_files))
      r$chapters <- factor(r$chapters , levels = r$chapters )
    }


    if ( file.exists( r$path %/% "_output.yml" ) ) {
      r$output_yml <- yaml.load(readLines(r$path %/% "_output.yml"))
    } else {
      file.copy(
        system.file("_output.yml", package = "backyard"),
        r$path %/% "_output.yml"
      )
      r$output_yml <- yaml.load(readLines(r$path %/% "_output.yml"))
    }

    if ( file.exists( r$path %/% "style.css" ) ) {
      r$style <- r$path %/% "style.css"
    } else {
      file.copy(
        system.file("style.css", package = "backyard"),
        r$path %/% "style.css"
      )
      r$style <- r$path %/% "style.css"
    }
  })

  output$ui <- renderUI({
    req(r$path)
    mod_home_pageui("mod_home_pageui", r$path)
  })
  observe({
    if (!is.null(r$path)) {
      callModule(mod_home_page, "mod_home_pageui", r = r)
    }
  })
}

#' @importFrom shiny modalDialog tags textInput div tagList actionButton
#' @importFrom shinyFiles shinyDirButton shinyFilesButton
opening <- function(failed = FALSE, both = FALSE, exists = FALSE) {
  modalDialog(
    tags$strong(
      "Create a new Bookdown"
    ),
    shinyDirButton(
      "dir",
      label = "Dir select",
      title = "Select a folder to create the book directory"
    ),
    textInput("namedir", "dir name", "bookdown"),
    tags$hr(),
    tags$strong("Point to the Index / First Rmd of your bookdown"),
    shinyFilesButton(
      "files",
      label = "File select",
      title = "Please select a file",
      multiple = FALSE
    ),
    if (failed) {
      div(tags$b("Please select a valid path", style = "color: red;"))
    },
    if (both) {
      div(tags$b("Please select only one option", style = "color: red;"))
    },
    if (exists) {
      div(tags$b("Directory already exists", style = "color: red;"))
    },
    footer = tagList(
      actionButton("ok", "OK")
    )
  )
}
