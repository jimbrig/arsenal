# install.packages("devtools")
# install.packages("usethis")
# install.packages("processx")
# install.packages("goodpractice")

# usethis::edit_r_profile()
# usethis::create_package(getwd())

library(devtools)
library(usethis)

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
use_test("my-test")

# rmd template setup
use_rmarkdown_template()

# data setup
use_data_raw("lossrun")


