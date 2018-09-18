mod_includeui <- function(id){
  ns <- NS(id)
  tagList(
    h2("In header"),
    shinyFilesButton(
      ns('in_header'),
      label='in_header select',
      title='Please select a file',
      multiple=FALSE
    ),
    h2("Before body"),
    shinyFilesButton(
      ns('before_body'),
      label='before_body select',
      title='Please select a file',
      multiple=FALSE
    ),
    h2("In header"),
    shinyFilesButton(
      ns('after_body'),
      label='after_body select',
      title='Please select a file',
      multiple=FALSE
    )
  )
}

mod_include <- function(input, output, session, r){
  ns <- session$ns

  roots <- c(wd = "/")

  shinyFileChoose(
    input,
    "in_header",
    roots = roots
  )

  # observeEvent(input$in_header, {
  #   browser()
  #   req(input$in_header)
  #   r$in_header <- parseFilePaths(roots, input$in_header)$datapath
  # })
  #
  # shinyFileChoose(input, ns('before_body'), roots=roots)
  # observeEvent(input$before_body, {
  #   req(input$before_body)
  #   r$in_header <- parseFilePaths(roots, input$before_body)$datapath
  # })
  # shinyFileChoose(input, ns('after_body'), roots=roots)
  # observeEvent(input$after_body, {
  #   req(input$after_body)
  #   r$in_header <- parseFilePaths(roots, input$after_body)$datapath
  # })
}
