## Server.R for deals

## Add tooltips to UI
addTooltip(session, id="origin", title = "This is an input.",
                      placement = "left", trigger = "hover")

## Determine how budget should show dollars vs points
observe( {
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
    budget <- list(min=0, max=max(fares$DollarFare), tag="dollars")
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
  ## input <- list(origin="BDL", dest="MCO", budget=200,
  ##               dates=as.Date(c("2015-12-20", "2015-12-27")),
  ##               destType="Family", faretype="dollars")
  ## print("DEBUGGING ON")
  ## ##  

  scoreList <- list()
  scoreList$OriginScore <- AirportScore(input$origin, flights=fares,
                                        type="Origin",
                                        airportRegions=dat$AirportRegion,
                                        nearby=input$nearbyOrigin)
  scoreList$DestScore <- AirportScore(input$dest, flights=fares,
                                      type="Destination",
                                      airportRegions=dat$AirportRegion,
                                      nearby=input$nearbyDest)
  scoreList$BudgetScore <- BudgetScore(input$budget, flights=fares,
                                       type=ifelse(input$pointsFlag, "points", "dollars"))
  scoreList$CalendarScore <- CalendarScore(dateOutboundStart=input$dates[1],
                                           dateOutboundEnd=input$dates[2],
                                           flights=fares, nearbyOutbound=FALSE)
  scoreList$DestinationTypeScore <- DestinationTypeScore(input$destType,
                                                         flights=fares,
                                                         dat$DestinationType,
                                                         dat$CityPairDestinationType)
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

