require(devtools)
require(usethis)

# documentation

# readme, CoC, News
use_readme_md()
use_code_of_conduct()
use_news_md()

# CI / Coverage and Badges
use_travis()
use_appveyor()
use_coverage()

use_lifecycle_badge("Experimental")
use_badge(
  "Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.",
  href = "http://www.repostatus.org/#wip",
  src = "https://www.repostatus.org/badges/latest/wip.svg"
)

# add hex logo
# use_logo("inst/img/owshiny-hex.png")
