deals.box <- fluidPage(
  headerPanel(
    inputPanel(
      selectInput("origin", "From", multiple=TRUE,
                  choices=as.character(sort(unique(dat$Fare$Origin)))),
      checkboxInput("nearbyOrigin", "Nearby?", value=FALSE),
      bsTooltip(id = "origin", title = "This is an input",
                          placement = "left", trigger = "hover"),
      selectInput("dest", "To", multiple=TRUE,
                  choices=as.character(sort(unique(dat$Fare$Destination)))),
      checkboxInput("nearbyDest", "Nearby?", value=FALSE),      
      dateRangeInput("dates", "Date",
                     start=min(dat$Fare$Day), end=max(dat$Fare$Day),
                     min=min(dat$Fare$Day), max=max(dat$Fare$Day)),
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
