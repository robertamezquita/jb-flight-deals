## Clear workspace (important for debugging in interactive session)
rm(list=ls())

## Load packages
library(shiny)
library(shinydashboard)
library(shinyapps)
library(markdown)

## Global variables - used across pages and apps
datGlobal <- NULL
updGlobal <- 0                          # initialize counter to 0
