`%||%` <- function (x, y) {
  if ( is.null(x) ) {
    y
  } else {
    x
  }
}

dropNulls <- getFromNamespace("dropNulls", "shiny")

drop_empty <- function(x){
  x <- lapply(x, nchar)
  x <- lapply(x, sum)
  x[!as.numeric(x) ==0]
}

`%/%` <- function(a, b){
  file.path(a, b)
}

#' @importFrom shinyalert shinyalert
saved <- function(){
  shinyalert("Done!", type = "success")
}

#' @importFrom shiny tags
list_to_li <- function(list){
  lapply(list, tags$li)
}

#' @importFrom shiny tags tagAppendAttributes
list_to_p <- function(list, class = NULL){
  if (is.null(class)){
    lapply(list, tags$p)
  } else {
    res <- lapply(list, tags$p)
    lapply(res, function(x) tagAppendAttributes(x, class = class))
  }

}

#' @importFrom glue glue
#' @importFrom shiny HTML
info_to_li <- function(list){
  HTML(glue("<li> <b>{names(list)}</b>: {list} </li>"))
}

is_index <- function(path){
  is(
    attempt::attempt(yaml::read_yaml(path), silent = TRUE),
    "try-error"
    )
}
