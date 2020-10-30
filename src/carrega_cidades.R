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

pop_mun_raw <- read_delim("~/Dropbox/Coding/R/data/populacao/pop_municipio_TCU_1992_2020.csv", 
                          ";", escape_double = FALSE, trim_ws = TRUE)
pop_mun_raw %>% 
  select(-Município)
names(pop_mun_raw)


pop_mun_raw
pop_cidade <- pop_mun_raw %>% 
  mutate(across(where(is.numeric), as.character)) %>% 
  pivot_longer(cols = -Município, names_to = "ano", values_to = "pop")  %>% 
  mutate(pop = as.numeric(pop),
         cod = str_sub(Município, 1, 6),
         Município = str_sub(Município, 8,-1L),
         uf = as.numeric(str_sub(cod, 1,2))) %>% 
  rename(municipio = Município)


