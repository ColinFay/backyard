# the goal of this file is to keep track of all devtools/usethis
# call you make for yout project

# Feel free to cherry pick what you need and add elements

# install.packages("desc")
# install.packages("devtools")
# install.packages("usethis")

# Hide this file from build
usethis::use_build_ignore("devstuff_history.R")

# If you want to use the MIT licence, code of conduct, lifecycle badge, and README
usethis::use_mit_license(name = "ThinkR")
usethis::use_readme_rmd()
usethis::use_code_of_conduct()
usethis::use_lifecycle_badge("Experimental")
usethis::use_news_md()

# For data
usethis::use_data_raw()

# For tests
usethis::use_testthat()
usethis::use_test("app")

# Dependencies
usethis::use_package("shiny")
usethis::use_package("DT")
usethis::use_package("stats")
usethis::use_package("graphics")
usethis::use_package("glue")

# Reorder your DESC

usethis::use_tidy_description()

# Vignette
usethis::use_vignette("backyard")
devtools::build_vignettes()

# Codecov
usethis::use_travis()
usethis::use_appveyor()
usethis::use_coverage()

# Test with rhub
rhub::check_for_cran()

# Favicons
download.file("https://use.fontawesome.com/releases/v5.2.0/css/all.css", "inst/www/favicons.css")

