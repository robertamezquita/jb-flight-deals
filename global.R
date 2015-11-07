## Clear workspace (important for debugging in interactive session)
rm(list=ls())

## Load packages
library(shiny)
library(shinydashboard)
library(shinyapps)
library(markdown)
library(DT)                     # Interface to the DataTables javascript library
library(dplyr)
library(tidyr)
source("DataParser/DataParser.R")       # read in data
funcs <- dir("ScoringFunctions", full.names=TRUE)
lapply(funcs, source)                   # source functions

## Global variables - used across pages and apps
