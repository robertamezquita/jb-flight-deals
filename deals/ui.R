deals.box <- fluidPage(
  headerPanel(
    inputPanel(
      selectInput("origin", "From", multiple=TRUE,
                  choices=as.character(sort(unique(dat$Fare$Origin)))),
      selectInput("dest", "To", multiple=TRUE,
                  choices=as.character(sort(unique(dat$Fare$Destination)))),
      dateRangeInput("dates", "Date", start=min(dat$Fare$Day), end=max(dat$Fare$Day)),
      uiOutput("budget"),
      selectInput("destType", "Trip Type (Ordered)", multiple=TRUE,
                  choices=as.character(dat$DestinationType$DestinationTypeName)),
      ## checkboxInput("nonstop", "Nonstop Only", value=FALSE),
      checkboxInput("pointsFlag", "Search By Points", value=FALSE)

      )
  ),
  DT::dataTableOutput("rankTable"),

  includeMarkdown('footer.md')
)
