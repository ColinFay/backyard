# mod_themingui <- function(id){
#   ns <- NS(id)
#   tagList(
#     column(
#       3,
#       h2("html_book"),
#       radioButtons(
#         ns("html_themes"),
#         "html_book themes",
#         choices = c("default", "cerulean", "journal", "flatly", "darkly", "readable","spacelab",
#                     "united","cosmo", "lumen","paper","sandstone","simplex","yeti", "null")
#       )
#     )
#   )
# }
#
# mod_theming <- function(input, output, session, r){
#   ns <- session$ns
# }
