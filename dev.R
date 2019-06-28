# install.packages("devtools")
# install.packages("usethis")
# install.packages("processx")
# install.packages("goodpractice")

# usethis::edit_r_profile()
# usethis::create_package(getwd())

library(devtools)
library(usethis)

use_git_config(user.name = "jimbrig2011", user.email = "jimmy.briggs@oliverwyman.com")

use_github()

git_sitrep()

use_roxygen_md()
devtools::document()

use_readme_md()

use_news_md()

use_test("my-test")

use_git()
edit_r_profile()
