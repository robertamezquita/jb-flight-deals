deals.box <- fluidPage(
  headerPanel(
    inputPanel(
      selectInput("faretype", "Fare Type", multiple=TRUE,
                  choices=c("dollars", "points"),
                  selected="dollars")
      )
  ),
  DT::dataTableOutput("rankTable"),

  includeMarkdown('footer.md')
)
