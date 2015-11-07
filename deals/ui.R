deals.box <- fluidPage(
  headerPanel(
    inputPanel(
      selectInput("origin", "From", multiple=TRUE,
                  choices=as.character(sort(unique(dat$Fare$Origin)))),
      selectInput("dest", "To", multiple=TRUE,
                  choices=as.character(sort(unique(dat$Fare$Destination)))),
      dateRangeInput("dates", "Date", start=min(dat$Fare$Day), end=max(dat$Fare$Day)),
      sliderInput("budget", "Budget", min=0, max=1500, value=200),
      selectInput("destType", "Trip Type (Ordered)", multiple=TRUE,
                  choices=as.character(dat$DestinationType$DestinationTypeName)),
      checkboxGroupInput("faretype", "Fares by",
                  choices=c("dollars", "points"),
                         selected="dollars"),
      checkboxInput("nonstop", "Nonstop Only", value=FALSE)
      )
  ),
  DT::dataTableOutput("rankTable"),

  includeMarkdown('footer.md')
)
