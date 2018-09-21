FROM rocker/tidyverse

MAINTAINER Colin FAY "contact@colinfay.me"

RUN R -e "install.packages('remotes', repos = 'https://cran.rstudio.com/')"
RUN R -e "remotes::install_github('ColinFay/backyard')"

RUN mkdir /usr/local/bookdown

COPY bookdown /usr/bookdown/bookdown

EXPOSE 2811

CMD R -e "backyard::run_app(indexrmd = '/usr/bookdown/bookdown',host = '0.0.0.0')"
