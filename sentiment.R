library(dplyr)
library(stringr)
library(rvest)
library(readr)
library(mongolite)
library(ggplot2)


con7 <-mongo(
  collection = "vil7",
  db = "edc",
  url = "mongodb://46.101.144.32",
  verbose = TRUE
)


