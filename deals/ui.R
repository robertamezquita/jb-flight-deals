### NOTE: Currently we assume mthat input$dest can be one or more airport codes, geographic regions, or market groups, whereas input$origin can be one or more airport codes ONLY.
deals.box <- fluidPage(
  fluidRow(
    column(3,
           popify(uiOutput("origin"),
                  title = "<b>Origin Airport</b>",
                  content = paste("Select one or more starting airports by code.",
                    "For example: <em>LAX</em>"),
                  placement = "bottom"),
           checkboxInput("nearbyOrigin", h5("Nearby Airports"), value=FALSE),
           dateRangeInput("dates", h3("Depart Date"),
                          start=Sys.Date()+7, end=Sys.Date()+7,
                          min=min(dat$Fare$Day), max=max(dat$Fare$Day))
           ),
    column(3, offset=1,
           popify(uiOutput("dest"),
                  title = "<b>Destination</b>",
                  content = paste("Select one or more destination",
                    "airports <b>or</b> regions.",
                    "For example: <em>BOS Northeast</em>"),
                  placement = "bottom"),
           checkboxInput("nearbyDest", h5("Nearby Airports"), value=FALSE)
           ),
    column(3, offset=1,
           uiOutput("budget"),
           popify(selectInput("destType", h3("Getaway"), multiple=TRUE,
                              choices=as.character(dat$DestinationType$DestinationTypeName)),
                  title = "<b>Getaway Type</b>",
                  content = paste("The type of trip you are looking for.",
                    "For example: <em>Family</em>"),
                  placement = "bottom"),
           ## checkboxInput("nonstop", "Nonstop Only", value=FALSE),
           checkboxInput("pointsFlag", h5("Search By Points"), value=FALSE)
           )
    ),

  ## Advanced options
  fluidRow(
    column(3,
           popify(uiOutput("origin"),
                  title = "<b>Origin Airport</b>",
                  content = paste("Select one or more starting airports by code.",
                    "For example: <em>LAX</em>"),
                  placement = "bottom"),
           checkboxInput("nearbyOrigin", h5("Nearby Airports"), value=FALSE),
           dateRangeInput("dates", h3("Depart Date"),
                          start=Sys.Date()+7, end=Sys.Date()+7,
                          min=min(dat$Fare$Day), max=max(dat$Fare$Day))
           ),
    column(3, offset=1,
           popify(uiOutput("dest"),
                  title = "<b>Destination</b>",
                  content = paste("Select one or more destination",
                    "airports <b>or</b> regions.",
                    "For example: <em>BOS Northeast</em>"),
                  placement = "bottom"),
           checkboxInput("nearbyDest", h5("Nearby Airports"), value=FALSE)
           ),
    column(3, offset=1,
           uiOutput("budget"),
           popify(selectInput("destType", h3("Getaway"), multiple=TRUE,
                              choices=as.character(dat$DestinationType$DestinationTypeName)),
                  title = "<b>Getaway Type</b>",
                  content = paste("The type of trip you are looking for.",
                    "For example: <em>Family</em>"),
                  placement = "bottom"),
           ## checkboxInput("nonstop", "Nonstop Only", value=FALSE),
           checkboxInput("pointsFlag", h5("Search By Points"), value=FALSE)
           )
    ),
  
  
  div(DT::dataTableOutput("rankTable", width="100%"), style = "font-size:150%")

  ## includeMarkdown('footer.md')
)


## THIS WORKS!
## deals.box <- fluidPage(
##   headerPanel(
##     inputPanel(
##       popify(uiOutput("origin"),
##              title = "<b>Origin Airport</b>",
##              content = paste("Select one or more starting airports by code.",
##                "For example: <em>LAX</em>"),
##              placement = "bottom"),
##       checkboxInput("nearbyOrigin", "Nearby Airports", value=FALSE),
##       popify(uiOutput("dest"),
##              title = "<b>Destination</b>",
##              content = paste("Select one or more destination airports <b>or</b> regions.",
##                "For example: <em>BOS Northeast</em>"),
##              placement = "bottom"),
##       checkboxInput("nearbyDest", "Nearby Airports", value=FALSE),      
##       dateRangeInput("dates", "Date",
##                      start=Sys.Date()+7, end=Sys.Date()+7,
##                      min=min(dat$Fare$Day), max=max(dat$Fare$Day)),
##       uiOutput("budget"),
##       popify(selectInput("destType", "Getaway", multiple=TRUE,
##                          choices=as.character(dat$DestinationType$DestinationTypeName)),
##              title = "<b>Getaway Type</b>",
##              content = paste("The type of trip you are looking for.",
##                "For example: <em>Family</em>"),
##              placement = "bottom"),
##       ## checkboxInput("nonstop", "Nonstop Only", value=FALSE),
##       checkboxInput("pointsFlag", "Search By Points", value=FALSE)
##       )
##   ),
##   DT::dataTableOutput("rankTable"),

##   includeMarkdown('footer.md')
## )
