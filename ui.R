## Define structure of dashboard
source("header.R")
source("sidebar.R")
source("body.R")

ui <- dashboardPage(
  skin = "blue",
  header, sidebar, body
)
