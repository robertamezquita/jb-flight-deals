deals.box <- fluidPage(
  headerPanel(
    inputPanel(
      checkboxGroupInput("faretype", "Fares by",
                  choices=c("dollars", "points"),
                  selected="dollars")
      )
  ),
  DT::dataTableOutput("rankTable"),

  includeMarkdown('footer.md')
)
