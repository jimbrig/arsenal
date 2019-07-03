require(usethis) # install.packages("usethis")
require(purrr) # install.packages("purrr")

# initialize package project
usethis::create_package("~/Documents/Projects/Playrground/arsenal")

# edit r profile
usethis::edit_r_profile()

# package skeleton
edit_file("DESCRIPTION")
use_namespace()
use_mit_license(name = "Oliver Wyman Actuarial Consulting, Inc.")
use_package_doc()
use_roxygen_md()
devtools::document()

# directory structure

# make a "config" folder to add configuration / development scripts like this
# one to and add it to the buildignore:
if (!dir.exists("config")) dir.create("config")
use_build_ignore("config")

# add a readme to the config directory
writeLines("# Package Configuration Scripts", "config/README.md")

# data-raw and data with readme's
use_data_raw("lossrun")
writeLines("# Raw Data", "data-raw/README.md")

dir.create("data")
writeLines("# Data", "data/README.md")
use_build_ignore("data/README.md")

# create directory to store images
dir.create("inst/img", recursive = TRUE)
imgs <- c(list.files("../../../Pictures/Code", pattern = "png", full.names = TRUE),
          list.files("../../../Pictures/OWAC", pattern = "png", full.names = TRUE))

purrr::pwalk(list(from = imgs, to = "inst/img"), file.copy)
rm(imgs)

# tests
use_testthat()

# vignettes
use_vignette("workflow", title = "Workflow")

# add a "dev" folder to R and buildignore it
# (used for funcitons still in progress)
dir.create("R/dev", recursive = TRUE)
use_build_ignore("R/dev")
