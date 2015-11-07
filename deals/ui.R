deals.box <- fluidPage(
  headerPanel(
    inputPanel(
      selectInput("faretype", "Fare Type", multiple=TRUE,
                  choices=("dollars", "points"),
                  selected="dollars")
      checkboxInput("test", label="Check", value=FALSE)
      )
  ),
  DT::dataTableOutput("rankTable"),

  includeMarkdown('footer.md')
)
