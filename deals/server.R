## Server.R for deals

## Add tooltips to UI
addTooltip(session, id="origin", title = "This is an input.",
                      placement = "left", trigger = "hover")


## Determine the appropriate destination ("To") fields based on the origin ("From")
observe({
  ## If no origin is selected, show everything
  if(is.null(input$origin)) {
    choices <- sort(unique(c(as.character(dat$Fare$Destination),
                             as.character(dat$MarketTable$GeographicRegionName),
                             as.character(dat$MarketTable$MarketGroupName))
                           ))
    
  } else {                              # some origin is selected
    codes <- as.character(unique(unlist(
      filter(dat$Fare, Origin %in% input$origin) %>% select(Destination))))
    regions <- filter(dat$MarketTable, AirportCode %in% codes) %>%
      select(GeographicRegionName, MarketGroupName)
    regions <- as.character(unique(unlist(regions)))
    choices <- sort(c(codes, regions))
  }
  output$dest <- renderUI({selectInput("dest", "To", multiple=TRUE, choices=choices)})
})

## Determine the appropriate origin ("From") fields based on the destination ("To")
observe({
  ## ## If no destination is selected, show everything
  ## if(is.null(input$dest)) {
    choices <- sort(unique(c(as.character(dat$Fare$Origin),
                             as.character(dat$MarketTable$GeographicRegionName),
                             as.character(dat$MarketTable$MarketGroupName))
                           ))
    
  ## } else {                   # some destination is selected so do some filtering
  ##   codes <- c()
  ##   for (destination in input$dest) {
  ##     ## Determine the type that is being considered
  ##     id <- data.frame(t(apply(marketTable[, c("AirportCode", "GeographicRegionName",
  ##                                              "MarketGroupName")], 2, function(x) {
  ##                                                destination[i] %in% x
  ##                                              })))

  ##     ## Switch: AirportCode
  ##     if (id["AirportCode"] == TRUE) {
  ##       search <- destination
  ##       ## Case: GeographicRegion
  ##     } else if (id["GeographicRegionName"] == TRUE) {
  ##       codes1 <- filter(dat$MarketTable, AirportCode %in% destination) %>%
  ##         select(GeographicRegionName)
  ##       search <- 
  ##       ## Case: MarketGroup
  ##     } else if (id["MarketGroupName"] == TRUE) {
  ##       rankList[[i]] <- MarketScore(bound[i], type, flights, marketTable)
  ##     }
  ##     codes <- c(codes, as.character(unique(unlist(
  ##       filter(dat$Fare, Destination %in% destination) %>% select(Origin)))))
      
  ##   }                                 # end for over length of input$dest
  ##   choices <- sort(codes)
  ## }
  output$dest <- renderUI({selectInput("origin", "From", multiple=TRUE, choices=choices)})
})



## Determine how budget should show dollars vs points
observe({
  if(input$pointsFlag) {
    fares <<- filter(dat$Fares, FareType == "POINTS")
    ## Points should not include tax
    fares$Points <<- format(fares$PointsFare, big.mark=",")
    fares$Tax <<- paste0("$", ceiling(fares$PointsTax))
    fares$Total <<- paste0(fares$Points, " + ",
                         "$", ceiling(fares$PointsTax), " tax")
    budget <- list(min=0, max=max(fares$PointsFare), tag="points")
  } else {
    fares <<- filter(dat$Fares, FareType == "LOWEST")
    ## Show pre-tax cost in dollars to be consistent with points
    fares$Dollars <<- paste0("$", ceiling(fares$DollarFare))
    fares$Tax <<- paste0("$", ceiling(fares$DollarTax))
    fares$Total <<- paste0("$", ceiling(fares$DollarFare + fares$DollarTax))
    budget <- list(min=0, max=max(fares$DollarFare + fares$DollarTax), tag="dollars")
  }
  output$budget <- renderUI({sliderInput("budget", paste0("Budget (", budget$tag, ")"),
                                         min=budget$min, max=ceiling(budget$max),
                                         value=mean(c(budget$min, budget$max)),
                                         step=10, round=2)})
})


## Display fares
outDat <- reactive({

  ## Select appropriate columns based on using points vs dollars
  selCols <- c("Day", "Departing")
  if (input$pointsFlag) {
    selCols <- c(selCols, "Points", "Tax", "Total")
  } else {
    selCols <- c(selCols, "Dollars", "Tax", "Total")
  }
  
  ## Validate the input
  validate(
    need(input$dates[2] >= input$dates[1], "end date is earlier than start date")
  )


  ## Create Naive Ranking
  ## Use:
  ## input$budget
  ## input$destType
  ## input$origin
  ## input$dest
  ## input$nonstop (TRUE /FALSE)
  ## input$dates (vector of length 2)

  ## ## DEBUGGING ONLY:
  ## input <- c(list(origin="JFK", dest=c("BOS", "MCO", "JAX"),
  ##                 dates=as.Date(c("2015-10-27", "2015-10-27")),
  ##                 budget=200,                  
  ##                 destType="Family", faretype="dollars"))
  ## print("DEBUGGING ON")
  ## ##  

  p1 <- 0.7
  p2 <- 0.7
  scoreList <- list()
  scoreList$OriginScore <- BoundScore(input$origin, flights=fares,
                                     type="Origin",
                                     nearby=input$nearbyOrigin,
                                     marketTable=dat$MarketTable,
                                     preferenceStrength=p1)
  scoreList$DestScore <- BoundScore(input$dest, flights=fares,
                                    type="Destination",
                                    nearby=input$nearbyDest,
                                    marketTable=dat$MarketTable,
                                    preferenceStrength=p1)
  scoreList$BudgetScore <- BudgetScore(input$budget, flights=fares,
                                       type=ifelse(input$pointsFlag, "points", "dollars"))
  scoreList$CalendarScore <- CalendarScore(dateOutboundStart=input$dates[1],
                                           dateOutboundEnd=input$dates[2],
                                           flights=fares)
  scoreList$DestinationTypeScore <- DestinationTypeScore(input$destType,
                                                         flights=fares,
                                                         dat$TypeTable,
                                                         preferenceStrength=p2)

  scoreMat <- Reduce(cbind, scoreList)
  cumScore <- CumulativeScore(scoreMat)
  fares$Score <- cumScore

  ord <- order(cumScore, decreasing=TRUE)

  ## Make a pretty column
  ## Proof that HTML can be added
  fares$Route <- paste(as.character(fares$Origin), as.character(icon("long-arrow-right")),
                       as.character(fares$Destination))
  selCols <- c("Route", selCols)

  ## Last-minute name changes just for printing
  colnames(fares) <- gsub("Day", "Date", colnames(fares))
  selCols <- gsub("Day", "Date", selCols)
  selCols <- c("Score",selCols)
  
  return(fares[ord,selCols])
})

output$rankTable <- DT::renderDataTable(outDat(),
                                        rownames=TRUE, # only for testing
                                        escape=FALSE,  # for allowing HTML to be rendered
                                        extensions=c("Scroller", "ColReorder", "ColVis"),
                                        options = list(
                                          ## columnDefs = list(list(orderable = FALSE,
                                          ##   targets = 0:(ncol(outDat())-1))),
                                          deferRender = TRUE,
                                          dom = 'C<"clear">frtSR',
                                          scrollY = "600px",
                                          scrollCollapse = TRUE))

