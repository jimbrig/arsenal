# install.packages("devtools")
# install.packages("usethis")
# install.packages("pkgbuild")
# install.packages("goodpractice")
# install.packages("testthat")

# usethis::edit_r_profile()
# usethis::create_package(getwd())

library(devtools)
library(usethis)

# check build tools
pkgbuild::check_build_tools()

# git confirguration / github project
use_git()
use_git_config(user.name = "jimbrig2011", user.email = "jimmy.briggs@oliverwyman.com")
use_github()
# git push --set-upstream origin master (shell command)
git_sitrep()

# documentation
use_package_doc()
use_roxygen_md()
devtools::document()

# readme and news
use_readme_md()
use_lifecycle_badge("Experimental")
use_news_md()

# test
use_testthat()
use_test("my-test")

# rmd template setup
use_rmarkdown_template()

# data setup
use_data_raw("lossrun")
# save this script in data-raw

# initial packages / imports
use_tibble() # @return a [tibble][tibble::tibble-package]
use_pipe() # added to utils.R file
use_package("utils")
use_package("lubridate")
use_package("dplyr")
use_package("stringr")
use_package("purrr")

# start building functions..
use_r("utils")

# make vignette
use_vignette("workflow", title = "Workflow")
