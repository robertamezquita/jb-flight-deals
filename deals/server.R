## Server.R for deals
fares <- dat$Fares

## Determine how budget should show dollars vs points
observe( {
  if(input$pointsFlag) {
    budget <- list(min=0, max=max(fares$PointsFare + fares$PointsTax),
                   tag="points")
  } else {
    budget <- list(min=0, max=max(fares$DollarFare + fares$DollarTax),
                   tag="dollars")
  }
  output$budget <- renderUI({sliderInput("budget", paste0("Budget (", budget$tag, ")"),
                                         min=budget$min, max=ceiling(budget$max),
                                         value=mean(c(budget$min, budget$max)),
                                         step=10, round=2)})
})


## Display fares
outDat <- reactive({

  ## Select appropriate columns based on using points vs dollars
  selCols <- c("Day", "Time", "Origin", "Destination")  
  if (input$pointsFlag) {
    fares$Points <- fares$PointsFare + fares$PointsTax
    selCols <- c("Points", selCols)
  } else {
    fares$Dollars <- fares$DollarFare + fares$DollarTax
    selCols <- c("Dollars", selCols)
  }
  
  ## Validate the input
  validate(
    need(input$dates[2] > input$dates[1], "end date is earlier than start date")
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
  ## input <- list(origin="BDL", dest="MCO", budget=200,
  ##               dates=as.Date(c("2015-12-20", "2015-12-27")),
  ##               destType="Family", faretype="dollars")
  ## print("DEBUGGING ON")
  ## ##  

  scoreList <- list()
  scoreList$OriginScore <- OriginScore(input$origin, flights=fares,
                                       airportRegions=dat$AirportRegion)
  scoreList$DestScore <- DestScore(input$dest, flights=fares,
                                   airportRegions=dat$AirportRegion)
  scoreList$BudgetScore <- BudgetScore(input$budget, flights=fares,
                                       type=ifelse(input$pointsFlag, "points", "dollars"))
  scoreList$CalendarScore <- CalendarScore(dateOutboundStart=input$dates[1],
                                           dateOutboundEnd=input$dates[2],
                                           flights=fares, nearbyOutbound=FALSE)
  scoreList$DestinationTypeScore <- DestinationTypeScore(input$destType,
                                                         flights=fares,
                                                         dat$CityPairDestinationType)
  scoreMat <- Reduce(cbind, scoreList)
  ord <- CumulativeScore(scoreMat)

  ## Proof that HTML can be added
  ## fares$Test <- as.character(icon("long-arrow-right"))
  ## selCols <- c(selCols, "Test")

  return(fares[ord,selCols])
})

output$rankTable <- DT::renderDataTable(outDat(),
                                        rownames=TRUE, # only for testing
                                        escape=FALSE,  # for allowing HTML to be rendered
                                        extensions=c("Scroller", "ColReorder", "ColVis"),
                                        options = list(
                                          columnDefs = list(list(orderable = FALSE,
                                            targets = 0:(ncol(outDat())-1))),
                                          deferRender = TRUE,
                                          dom = 'C<"clear">frtSR',
                                          scrollY = "600px",
                                          scrollCollapse = TRUE))

