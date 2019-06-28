# install.packages("devtools")
# install.packages("usethis")
# install.packages("processx")
# install.packages("goodpractice")


library(devtools)
library(usethis)

usethis::use_usethis()

use_description(fields = getOption("usethis.description"))

edit_file("DESCRIPTION")

use_mit_license("Oliver Wyman Actuarial Consulting, Inc.")

use_roxygen_md()
devtools::document()

use_readme_md()

use_news_md()
