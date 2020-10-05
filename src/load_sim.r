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
library(read.dbc)
library(datasus)
library(microdatasus)
library(sidrar)
library(ribge)

Sys.setenv(TZ="Brazil/East")
options(tz="Brazil/East")
Sys.getenv("TZ")
options(scipen = 999999)
Sys.setlocale("LC_TIME", "pt_BR")

source("~/Dropbox/Coding/R/funs/msrfun.R")

search_sidra("lista estados")


sim18_raw <- fetch_datasus(year_start = 2018, year_end = 2018,uf = "all", information_system = "SIM-DO") 
sim18_raw <- sim18_raw %>% 
  mutate( CODMUNOCOR = as.numeric(CODMUNOCOR))
ext18 <- fetch_datasus(year_start = 2018, year_end = 2018,uf = "all", information_system ="SIM-DOEXT")
ext18
sim18_raw$cod
sim18 <- left_join(sim18_raw, populacao, by = c("CODMUNOCOR" = "cod_munic6") )
names(populacao)
populacao <- ribge::populacao_municipios(ano = 2020)

saveRDS(sim18, "bin/sim.rds")

