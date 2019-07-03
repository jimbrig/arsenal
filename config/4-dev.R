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

# rmd template setup
use_rmarkdown_template()

# test
use_test("dates")
use_test("files")

