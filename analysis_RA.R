## Analysis of data R

## Libraries
library(dplyr)
library(reshape2)
library(ggplot2)
library(tidyr)

## Data read in
files <- list.files("data", full.names = T)
dat <- lapply(files, read.csv)
names(dat) <- list.files("data")

lapply(dat, head)





