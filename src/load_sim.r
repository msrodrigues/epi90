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


sim_raw <- fetch_datasus(year_start = 2017, year_end = 2018,uf = "all", information_system = "SIM-DO") 
ext_raw <- fetch_datasus(year_start = 1997, year_end = 2018,uf = "all", information_system ="SIM-DOEXT")
cnes <- fetch_datasus(year_start = 2020, year_end = 2020,
                      month_start = 1, month_end = 12,
                      uf = "all", information_system = "CNES-ST")

pop_mun_raw <- read_delim("~/Dropbox/Coding/R/data/populacao/pop_municipio_TCU_1992_2020.csv", 
                          ";", escape_double = FALSE, trim_ws = TRUE)
names(pop_mun_raw)



pop_mun_raw
pop_cidade <- pop_mun_raw %>% 
  mutate(across(where(is.numeric), as.character)) %>% 
  pivot_longer(cols = -Município, names_to = "ano", values_to = "pop")  %>% 
  mutate(pop = as.numeric(pop),
         ano = as.numeric(ano),
         Município = str_sub(Município, 8,-1L)) %>% 
  rename(municipio = Município)


city_raw <- read_excel("~/Dropbox/Coding/R/data/brasil/Município, por Grande Região.xlsx")
names(city_raw) <- c("cod_regiao", "regiao", "cod_ibge", "municipio")

city <- city_raw %>% 
  mutate(cod_uf = as.numeric(str_sub(cod_ibge,1,2)))

uf_regiao <- read_excel("~/Dropbox/Coding/R/data/brasil/uf_por_regiao.xlsx")  
names(uf_regiao) <- c("cod_regiao", "regiao", "cod_uf", "uf")


cidades <- left_join(city, uf_regiao, by = c("cod_regiao", "regiao", "cod_uf")) %>% 
  dplyr::right_join(pop_cidade, by = c("municipio"))

glimpse(cidades)

Desc(cidades$cod_ibge)

Desc(cidades$ano)
info_sidra(x = 200)
mortalidade <- get_sidra(x = 200,
          variable = "allxp",
          period = c("1970, 1980, 1991, 2000, 2010"),
          geo = "Brazil",
          header = TRUE,
          format = 4)

saveRDS(sim_raw, "bin/sim.rds")
saveRDS(ext_raw, "bin/ext.rds")

