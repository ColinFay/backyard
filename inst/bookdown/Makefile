html:
	Rscript -e 'bookdown::render_book("index.Rmd", output_format = "bookdown::gitbook", clean = FALSE)'
	cp -fvr style.css _book/
	cp -fvr images _book/

build:
	make html
	Rscript -e 'browseURL("_book/index.html")'
	
pdf:
	Rscript -e 'bookdown::render_book("index.Rmd", output_format = "bookdown::pdf_book")'

md:
	Rscript -e 'bookdown::render_book("index.Rmd", output_format = "bookdown::pdf_book", clean = FALSE)'
	
#deploy:
#	Rscript -e 'bookdown::publish_book(render="local", account="gaston")'

clean:
	Rscript -e "bookdown::clean_book(TRUE)"
	rm -fvr _bookdown_files

cleaner:
	make clean
	rm -frv *.aux *.out  *.toc # Latex output
	rm -fvr *.html # rogue html files
	