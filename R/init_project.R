#' @title Initialize an 'RStudio' Project or a Shiny Application
#'
#' @description Create a new RStudio project then launch this addin.
#' You will be able to create folders and scripts to start your analysis/project/application in no time.
#'
#' @details You can change some default parameters if you want, look at example below, here's the full list of parameters :
#' \itemize{
#'  \item \strong{author:} The value to use by default for author input, used when creating a script from template.
#'  \item \strong{folders.default:} The names of the directories to create.
#'  \item \strong{folders.selected:} Select folders to create by default.
#'  \item \strong{packages.default:} A vector of packages to load in scripts, by default all packages installed.
#'  \item \strong{packages.selected:} Select packages to load by default.
#'  \item \strong{config:} Add a config script or not at the root of the projects for loading data, sourcing funs, ...
#'  \item \strong{source_funs:} Add code to source functions.
#'  \item \strong{create_template:} Make Shiny template selection appear.
#'  \item \strong{template:} Template to create, `shiny` for a classic shiny app (ui, server, global), `dashboard` for use shinydashboard, `miniapp` for a single file app (app.R)
#' }
#'
#'
#' @return the return of \code{\link[shiny]{runGadget}}
#' @export
#'
#' @importFrom utils installed.packages modifyList
#' @importFrom shiny runGadget dialogViewer
#'
#' @examples
#' \dontrun{
#' # you can launch the addin via the RStudio Addins menu
#' # or in the console :
#' arsenal::initProject()
#'
#' # Change default parameters
#' # (you can put this in your Rprofile) :
#' my_custom_params <- list(
#'   author = "Your Name",
#'   project = list(
#'     folders = list(
#'       default = c("R", "inst", "man", "data-raw", "data", "tests"),
#'       selected = c("R", "man")
#'     ),
#'     packages = list(
#'       default = rownames(installed.packages()),
#'       selected = "shiny"
#'     )
#'   )
#' )
#' options("arsenal" = my_custom_params)
#'
#' # Then relaunch the addin
#' }
initProject <- function() {

  # Parameters
  params_default <- list(
    author = NULL,
    project = list(
      folders = list(
        default = c("R", "data", "data-raw", "man", "outputs", "logs", "tests",
                    "scripts", "reports", "admin")
      ),
      packages = list(
        default = rownames(utils::installed.packages()),
        selected = NULL
      ),
      config = TRUE,
      source_funs = FALSE
    ),
    application = list(
      folders = list(
        default = c("data", "R", "www")
      ),
      packages = list(
        default = rownames(installed.packages()),
        selected = NULL
      ),
      create_template = TRUE,
      template = "dashboard"
    )
  )

  params <- utils::modifyList(x = params_default, val = getOption(x = "arsenal", default = list()))

  # Addin ---
  viewer <- shiny::dialogViewer("Initialize a project.", width = 1000, height = 700)
  # viewer <- browserViewer()
  shiny::runGadget(app = initProjectUI(params), server = initProjectServer, viewer = viewer)

}

#' UI for initProject Addin
#'
#' @noRd
#'
#' @importFrom miniUI miniPage miniTitleBarButton miniTabstripPanel miniTabPanel miniContentPanel
#' @importFrom shiny icon
#' @importFrom htmltools tags
#'
initProjectUI <- function(params) {

  miniPage(
    # CSS
    tags$link(rel = "stylesheet", type = "text/css", href = "arsenal/arsenal.css"),

    # header
    tags$div(
      class = "gadget-title arsenal-header",
      tags$div(icon("lightbulb-o"), "Init Project", class = "arsenal-title"),
      tags$div(
        class = "pull-left",
        miniTitleBarButton(inputId = "help", label = "Help")
      ),
      tags$div(
        class = "pull-right",
        miniTitleBarButton(inputId = "cancel", label = "Close")
      )
    ),

    toggleInputUi(),

    # tabs
    miniTabstripPanel(
      id = "tabs",

      # tab organize project ----
      miniTabPanel(
        title = "Organize your project",
        value = "project",
        icon = icon("folder"),
        miniContentPanel(

          createFoldersUi(id = "project", params = params$project, title = "Create folders")

          , tags$br(),

          createScriptsProjectUI(
            id = "project-scripts",
            params = params$project,
            author  = getOption(x = "arsenal.author", default = params$author)
          )

        ),
        miniUI::miniButtonBlock(
          actionButton(
            inputId = "add_readme",
            label = "Add README",
            class = "btn-primary",
            icon = icon("file-text")
          )
        )
      ),

      # tab organize shiny app ----
      miniTabPanel(
        title = "Organize your Shiny app",
        value = "application",
        icon = icon("cubes"),
        miniContentPanel(

          createFoldersUi(id = "application", params = params$application, title = "Create folders")

          , tags$br(),

          createScriptsAppUI(
            id = "apps-scripts",
            params = params$application,
            author  = getOption(x = "arsenal.author", default = params$author)
          )

        )
      )
    )

  )

}




#' Server for initProject Addin
#'
#' @param input   standard \code{shiny} input
#' @param output  standard \code{shiny} output
#' @param session standard \code{shiny} session
#'
#' @noRd
#'
#' @importFrom shiny observeEvent showModal modalDialog callModule stopApp modalButton
#' @importFrom htmltools tags
#' @importFrom usethis use_readme_md
#'
initProjectServer <- function(input, output, session) {

  # Help modal
  observeEvent(input$help, {
    showModal(modalDialog(
      title = NULL,
      easyClose = TRUE,
      fade = FALSE,
      size = "m",
      footer = tags$p(
        tags$a(
          tags$img(src = "arsenal/owi-logo.png", align = "left", style = "width:13%"),
          href = "https://www.oliverwyman.com/index.html"
        ),
        modalButton("Cancel")
      ),
      helpModal()
    ))
  })

  trigger_new_dirs <- reactiveValues(x = Sys.time())
  observeEvent(update_folders_project$x, {
    trigger_new_dirs$x <- Sys.time()
  })
  observeEvent(update_folders_shiny$x, {
    trigger_new_dirs$x <- Sys.time()
  })

  # Project ----

  callModule(
    module = createFoldersServer,
    id = "project"
  ) -> update_folders_project

  callModule(
    module = createScriptsProjectServer,
    id = "project-scripts",
    trigger = trigger_new_dirs
  )

  toggleInputServer(
    session = session,
    inputId = "add_readme",
    enable = !file.exists("README.md")
  )
  observeEvent(input$add_readme, usethis::use_readme_md())


  # App ----

  callModule(
    module = createFoldersServer,
    id = "application"
  ) -> update_folders_shiny


  callModule(
    module = createScriptsAppServer,
    id = "apps-scripts",
    trigger = trigger_new_dirs
  )

  # close app ----
  observeEvent(input$cancel, stopApp())
}

