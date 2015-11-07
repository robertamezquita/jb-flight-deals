deals.box <- fluidPage(
  headerPanel("Rank Fares"),
  sidebarPanel(
    inputPanel(
      checkboxInput("test", label="Check", value=FALSE)
      )
  ),
  mainPanel(
    tabsetPanel(type = "tabs",
                tabPanel("Flights", dataTableOutput("rankTable")))
  ),
  includeMarkdown('footer.md')
)
