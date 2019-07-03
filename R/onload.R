#' Adds the content of www to addinCron/
#'
#' @importFrom shiny addResourcePath
#'
#' @noRd
#'
.onLoad <- function(...) {
  shiny::addResourcePath('arsenal', system.file('www', package = 'arsenal'))
}
