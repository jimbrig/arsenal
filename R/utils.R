## quiets concerns of R CMD check re: the .'s that appear in pipelines
if (getRversion() >= "2.15.1")  utils::globalVariables(c("."))

#' Pipe operator
#'
#' See \code{magrittr::\link[magrittr:pipe]{\%>\%}} for details.
#'
#' @name %>%
#' @rdname pipe
#' @keywords internal
#' @export
#' @importFrom magrittr %>%
#' @usage lhs \%>\% rhs
NULL


# # Utils ----
`%||%` <- function(a, b) {
  if (!is.null(a)) a else b
}

#' Create directories
#'
#' @param paths Valid path(s)
#'
#' @return a logical
#' @noRd
#'
create_dirs <- function(paths) {
  status <- logical(0)
  for (i in seq_along(paths)) {
    status[i] <- dir.create(path = paths[i], showWarnings = FALSE)
  }
  return(status)
}

#' Message for modal on status of dirs creation
#'
#' @param dirs List of dirs
#' @param status Logical, status of creation
#'
#' @return a logical
#' @noRd
#'
#' @importFrom htmltools tags HTML
#'
create_dirs_msg <- function(dirs, status) {
  status_icon <- ifelse(
    status,
    yes = '<i class="fa fa-check-circle fa-2x" style="color: rgb(0, 102, 0);"></i>',
    no = '<i class="fa fa-exclamation-circle fa-2x" style="color: rgb(255, 0, 0);"></i>'
  )
  status_text <- ifelse(
    status,
    yes = 'Folder successfully created',
    no = 'Error : the folder already exist or invalid path'
  )
  tags$ul(
    class = "fa-ul",
    lapply(
      X = paste(paste(status_icon, paste0("<b>", dirs, "</b>"), sep = " "), status_text, sep = " : "),
      FUN = function(x) {
        tags$li(HTML(x))
      }
    )
  )
}

#' Create a script with header
#'
#' @param path Where to create the file.
#' @param name Script's name.
#' @param author Author of the script.
#' @param title Title of the script.
#' @param packages Package to load in the script.
#'
#' @noRd
#'
#' @importFrom usethis use_template
create_script <- function(path = ".", name = "script", author = "", title = "", packages = "") {
  use_template(
    template = "script.R",
    save_as = file.path(path, paste0(name, ".R")),
    open = TRUE,
    data = list(
      author = author %||% "",
      date = format(Sys.Date(), format = "%F"),
      title = title %||% "",
      packages = load_packages(packages)
    ),
    package = "arsenal"
  )
}

#' Generate script to load packages
#'
#' @param packages a character vector of packages to load
#'
#' @return a string
#' @noRd
#'
#' @examples
#' \dontrun{
#' load_packages(NULL)
#' load_packages("")
#' load_packages("data.table")
#' }
load_packages <- function(packages) {
  if (is.null(packages))
    packages <- ""

  if (packages[1] != "") {
    packages <- paste0("library(\"", packages, "\")")
    packages <- paste(packages, collapse = "\n")
    packages <- paste(
      "# Packages ----------------------------------------------------------------",
      "",
      packages, sep = "\n"
    )
  }

  return(packages)
}


#' Initialize a Shiny app from template
#'
#' @param type Tpe of script : script, shiny, dashboard, miniapp.
#' @param ... additionnal arguments to put in the template
#'
#' @importFrom utils modifyList
#' @importFrom usethis use_template
#' @noRd
create_app <- function(type, ...) {
  args <- list(...)
  args_default <- list(
    path = ".",
    name = "script",
    author = "",
    title = "",
    packages = "",
    date = format(Sys.Date(), format = "%F")
  )
  args <- modifyList(x = args_default, val = args)
  args$packages <- load_packages(args$packages)
  type <- match.arg(
    arg = type,
    choices = c("shiny", "dashboard", "miniapp")
  )
  if (type == "miniapp") {
    use_template(
      template = "miniapp/app.R",
      save_as = file.path(args$path, "app.R"),
      open = TRUE,
      data = args,
      package = "arsenal"
    )
  } else if (type == "shiny") {
    use_template(
      template = "shiny/ui.R",
      save_as = file.path(args$path, "ui.R"),
      open = TRUE,
      data = args,
      package = "arsenal"
    )
    use_template(
      template = "shiny/server.R",
      save_as = file.path(args$path, "server.R"),
      open = TRUE,
      data = args,
      package = "arsenal"
    )
    use_template(
      template = "shiny/global.R",
      save_as = file.path(args$path, "global.R"),
      open = TRUE,
      data = args,
      package = "arsenal"
    )
  } else if (type == "dashboard") {
    use_template(
      template = "dashboard/ui.R",
      save_as = file.path(args$path, "ui.R"),
      open = TRUE,
      data = args,
      package = "arsenal"
    )
    use_template(
      template = "dashboard/server.R",
      save_as = file.path(args$path, "server.R"),
      open = TRUE,
      data = args,
      package = "arsenal"
    )
    use_template(
      template = "dashboard/global.R",
      save_as = file.path(args$path, "global.R"),
      open = TRUE,
      data = args,
      package = "arsenal"
    )
  }
}





