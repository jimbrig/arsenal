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
use_r("init")

# rmd template setup
use_rmarkdown_template()

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

