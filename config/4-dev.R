# install.packages("devtools")
# install.packages("usethis")
# install.packages("pkgbuild")
# install.packages("goodpractice")
# install.packages("testthat")
# install.packages("pacman")

library(devtools)
library(usethis)

# check build tools
pkgbuild::check_build_tools()

# start building functions..
use_r("utils")
use_r("dates")
use_r("leftright")
use_r("files")
use_r("folders_module")
use_r("scripts_module")
use_r("project_module")
use_r("help")
use_r("init_project")
use_r("onload")
use_r("project_templates")
use_r("addins")
use_r("shinyutils")
use_r("tryalert")
#use_r("")

# rmd template setup
use_rmarkdown_template()

# gadget setup
usethis::use_addin()
dir.create("inst/rstudio/templates/project", recursive = TRUE)
file.copy("inst/rstudio/addins.dcf", "inst/rstudio/templates/project/rst_create_study.dcf")

# www folder
dir.create("inst/www", recursive = TRUE)
# add css, java, img files here

# script and config template
dir.create("inst/templates", recursive = TRUE)
# add script.R and config.R templates to this folder

# app
dir.create("inst/templates/app", recursive = TRUE)
# add app.R here

# dashboard
dir.create("inst/templates/dashboard", recursive = TRUE)
# add global.R, server.R, and ui.R here

# shiny
dir.create("inst/templates/shiny", recursive = TRUE)
# add global.R, server.R, and ui.R here

# test
use_test("leftright")
use_test("dates")
use_test("files")

test_coverage()
usethis::use_covr_ignore(
  c(
    "R/addins.R",
    "R/folders_module.R",
    "R/help.R",
    "R/init_project.R",
    "R/onload.R",
    "R/project_module.R",
    "R/project_templates.R",
    "R/scripts_module.R",
    "R/tryalert.R",
    "R/shinyutils.R",
    "R/utils.R"
  )
)
