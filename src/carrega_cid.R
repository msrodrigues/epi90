library(openxlsx)
library(scales)
library(readxl)
library(WriteXLS)
library(ggthemes)
library(RColorBrewer)
library(lubridate)
library(caret)
library(tidyverse)
library(here)
library(usethis)
library(googlesheets4)
library(DescTools)
library(obAnalytics)
library(collapse)
library(tictoc)

Sys.setenv(TZ="Brazil/East")
options(tz="Brazil/East")
Sys.getenv("TZ")
options(scipen = 999999)
Sys.setlocale("LC_TIME", "pt_BR")

source("~/Dropbox/Coding/R/funs/msrfun.R")

urlfile="https://raw.githubusercontent.com/msrodrigues/CidDataSus/master/CIDImport/Repositorio/Resources/CID-10-SUBCATEGORIAS.CSV"

cid10 <-read_delim(url(urlfile), delim = ";", locale = locale(encoding = "latin1"))

fogo <- cid10 %>% 
  filter(grepl("((arma|armas) de fogo)", DESCRICAO)) %>% 
  select(SUBCAT) %>% pull()


