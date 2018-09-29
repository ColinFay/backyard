withr::with_dir("manual/", {bookdown::render_book("index.Rmd", output_dir = "../docs")})
