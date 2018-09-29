withr::with_dir("manual/", {bookdown::render_book("index.Rmd", output_dir = "../docs")})
withr::with_dir("docs/", {file.rename("introduction.html", "index.html")})
