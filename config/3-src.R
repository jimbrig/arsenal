require(usethis)

# initial packages / imports
use_tibble() # @return a [tibble][tibble::tibble-package]
use_pipe() # added to utils.R file and changed topic to be "pipe" instead of "%>%"

# add packages here as needed while creating functions
use_package("utils")
use_package("lubridate")
use_package("dplyr")
use_package("stringr")
use_package("purrr")
# use_package("fs")

use_package("shiny")
use_package("shinydashboard")
use_package("rstudioapi")
use_package("shinyWidgets")
use_package("htmltools")
use_package("usethis")

use_package("miniUI")
use_package("markdown")

# install.packages("R.utils")
# use_package("R.utils")

# flipTime package for "AsDate" function:
use_dev_package("flipTime") # install_github("Displayr/flipTime")
