#' List directories excluding temporary, Rproj, and git removing internal
#' undesired files
#'
#' @param path (String) Valid path
#' @param pat (String) Pattern to match. Defaults to NULL.
#' @param full (Logical) Return full path? Defaults to FALSE.
#' @param named (Logical) Add names? Defaults to FALSE.
#'
#' @return A character vector containing the files in the specified directory
#' excluding any temporary unwanted files (i.e. "~$file.xlsx"), Rproj files, and git files.
#'
#' @importFrom purrr discard
#' @importFrom stringr str_detect fixed
#'
#' @export
#'
#' @examples
#' list_files(getwd())
list_files <- function(path, pat = NULL, full = FALSE, named = FALSE){

  hold <- list.files(path, pattern = pat, full.names = full) %>%
    purrr::discard(stringr::str_detect(string = .,
                                       pattern = stringr::fixed("~$"))) %>%
    purrr::discard(stringr::str_detect(string = .,
                                       pattern = stringr::fixed(".Rproj"))) %>%
    purrr::discard(stringr::str_detect(string = .,
                                       pattern = stringr::fixed(".git")))

  if (named) names(hold) <- list.files(path, pattern = pat, full.names = FALSE)

  return(hold)

}
