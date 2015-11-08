deals.box <- fluidPage(
  headerPanel(
    inputPanel(
      selectInput("origin", "From", multiple=TRUE,
                  choices=sort(unique(c(as.character(dat$Fare$Origin),
                    as.character(dat$MarketTable$GeographicRegionName),
                    as.character(dat$MarketTable$MarketGroupName))
                    ))),
      checkboxInput("nearbyOrigin", "Nearby?", value=FALSE),
      bsTooltip(id = "origin", title = "This is an input",
                          placement = "left", trigger = "hover"),
      selectInput("dest", "To", multiple=TRUE,
                  choices=as.character(sort(unique(dat$Fare$Destination)))),
      checkboxInput("nearbyDest", "Nearby?", value=FALSE),      
      dateRangeInput("dates", "Date",
                     start=Sys.Date()+7, end=Sys.Date()+7,
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
