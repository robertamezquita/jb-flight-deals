## Clear workspace (important for debugging in interactive session)
rm(list=ls())

## Load packages
library(shiny)
library(shinyBS)                        # Additional Bootstrap Controls
library(shinydashboard)
library(shinyapps)
library(markdown)
library(DT)                     # Interface to the DataTables javascript library
library(scales)
library(dplyr)
library(tidyr)
source("DataParser/DataParser.R")       # read in data
funcs <- dir("ScoringFunctions", full.names=TRUE)
funcs <- grep(".R$", funcs, value=TRUE) # make sure to only source R files
lapply(funcs, source)                   # source functions

## Global variables - used across pages and apps


## Simple function to print numeric value as money character string
## printMoney <- function(x, nsmall=0, ...){
##   if(!all(is.numeric(x))) {
##     stop("x must be numeric to printMoney")
##   }
##   mon <- format(x, digits=10, scientific=FALSE, nsmall=nsmall,
##                 decimal.mark=".", big.mark=",", ...)
##   paste("$", mon)
## }
