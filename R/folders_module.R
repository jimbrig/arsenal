#' Module for creating folders
#'
#' @param id Module's id
#' @param params List of parameters, e.g. names of directory to create
#' @param title Title to display
#'
#' @return a \code{shiny::\link[shiny]{tagList}} containing UI elements
#' @noRd
#'
#' @importFrom shiny NS tagList fluidRow column tags textInput actionButton icon
#' @importFrom shinyWidgets checkboxGroupButtons
#' @importFrom htmltools tags
#'
createFoldersUi <- function(id, params, title = "Create folders") {

  # Namespace
  ns <- NS(id)

  tagList(
    fluidRow(
      column(
        width = 12,
        tags$hr(class = "arsenal-hr"),
        tags$h4(title, class = "addInit-h4"),
        tags$hr(class = "arsenal-hr")
      )
    ),
    fluidRow(
      column(
        width = 8,
        tags$h4("Folders :", class = "arsenal-label"),
        checkboxGroupButtons(
          inputId = ns("folders"),
          label = NULL,
          choices = params$folders$default,
          selected = params$folders$selected,
          justified = TRUE,
          status = "info",
          checkIcon = list(yes = tags$i(class = "fa fa-check-square"),
                           no = tags$i(class = "fa fa-square-o"))
        )
      ),
      column(
        width = 4,
        tags$h4("Others :", class = "arsenal-label"),
        textInput(
          inputId = ns("folders_other"),
          label = NULL,
          placeholder = "folder1;folder2 "
        )
      )
    ),
    fluidRow(
      column(
        width = 12,
        tags$div(
          class = "pull-right",
          tags$br(),
          actionButton(
            inputId = ns("folders_create"),
            label = "Create folders!",
            icon = icon("folder-o"),
            class = "btn-primary"
          )
        )
      )
    )
  )
}

#' Module for creating folders
#'
#' @param input   standard \code{shiny} input
#' @param output  standard \code{shiny} output
#' @param session standard \code{shiny} session
#'
#' @return a reactiveValues updated each time folders are created
#' @noRd
#'
#' @importFrom htmltools tags
#' @importFrom shiny reactiveValues observeEvent showModal modalDialog updateTextInput
#' @importFrom shinyWidgets updateCheckboxGroupButtons
#'
createFoldersServer <- function(input, output, session) {

  # Namespace
  ns <- session$ns

  res <- reactiveValues(x = NULL)

  observeEvent(input$folders_create, {
    folders <- c(input$folders, unlist(strsplit(input$folders_other, split = ";")))
    status_folders <- create_dirs(file.path(".", folders))
    showModal(modalDialog(
      title = "Folders creation",
      create_dirs_msg(
        folders,
        status_folders
      )
    ))
    updateCheckboxGroupButtons(
      session = session,
      inputId = "folders",
      selected = character(0),
      status = "info"
    )
    updateTextInput(
      session = session,
      inputId = "folders_other",
      value = ""
    )
    res$x <- c(res$x, input$folders_create)
  })

  return(res)
}



