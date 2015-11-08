## Server.R for deals

## Add tooltips to UI
addTooltip(session, id = "nearbyOrigin",
                title = "Check to include airports nearby those selected",
                placement = "bottom", trigger = "hover")
addTooltip(session, id = "nearbyDest",
                title = "Check to include airports nearby those selected",
           placement = "bottom", trigger = "hover")
addTooltip(session, id = "dates",
                title = "Add Start and End Dates",
           placement = "bottom", trigger = "hover")
addTooltip(session, id = "pointsFlag",
           title = "Check to search by points instead of dollars",
           placement = "bottom", trigger = "hover")
addTooltip(session, id = "budget",
           title = "Position the slider to fit your budget",
           placement = "bottom", trigger = "hover")


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
    if(input$nearbyOrigin) {
      if(!is.null(input$origin)) {
        regs <- dplyr::filter(dat$MarketTable, AirportCode %in% input$origin) %>%
          select(GeographicRegionName)
        newcodes <- dplyr::filter(dat$MarketTable, GeographicRegionName %in% regs$GeographicRegionName) %>%
          select(AirportCode)
        codes <- c(codes, as.character(newcodes$AirportCode))
      }
    } 
    regions <- filter(dat$MarketTable, AirportCode %in% codes) %>%
      select(GeographicRegionName, MarketGroupName)
    regions <- as.character(unique(unlist(regions)))
    choices <- sort(c(codes, regions))
  }
  output$dest <- renderUI({selectInput("dest", h3("To"), multiple=TRUE, choices=choices)})
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
  output$origin <- renderUI({selectInput("origin", h3("From"), multiple=TRUE, choices=choices)})
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
  output$budget <- renderUI({sliderInput("budget", h3(paste0("Budget (", budget$tag, ")")),
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
  ##                 p <- 0.7
  ##                 destType="Family", faretype="dollars"))
  ## print("DEBUGGING ON")
  ## ##  

  ## Set `p`, the order importance or preferenceStrength
  if(is.null(input$p)) {
    p <- 0.7
  } else {
    p <- input$p 
  }
  scoreList <- list()
  scoreList$OriginScore <- BoundScore(input$origin, flights=fares,
                                     type="Origin",
                                     nearby=input$nearbyOrigin,
                                     marketTable=dat$MarketTable,
                                      preferenceStrength=p)
  scoreList$DestScore <- BoundScore(input$dest, flights=fares,
                                    type="Destination",
                                    nearby=input$nearbyDest,
                                    marketTable=dat$MarketTable,
                                    preferenceStrength=p)
  scoreList$BudgetScore <- BudgetScore(input$budget, flights=fares,
                                       type=ifelse(input$pointsFlag, "points", "dollars"))
  scoreList$CalendarScore <- CalendarScore(dateOutboundStart=input$dates[1],
                                           dateOutboundEnd=input$dates[2],
                                           flights=fares)
  scoreList$DestinationTypeScore <- DestinationTypeScore(input$destType,
                                                         flights=fares,
                                                         dat$TypeTable,
                                                         preferenceStrength=p)

  scoreMat <- Reduce(cbind, scoreList)

  ## Handle the coeficients (if they exist)
  if (input$advOptions) {
    coefs <- c(input$originCoef, input$destCoef,
               input$budgetCoef, input$calendarCoef,
               input$dstCoef)
  } else {
    coefs <- rep(1, ncol(scoreMat))
  }
  ## Calculate the final score
  cumScore <- CumulativeScore(scoreMat, matrix(coefs, nrow=1))
  fares$Score <- cumScore

  ord <- order(cumScore, decreasing=TRUE)

  ## Make a pretty column
  ## Proof that HTML can be added
  fares$Route <- paste(as.character(fares$Origin), as.character(icon("long-arrow-right")),
                       as.character(fares$Destination))
  selCols <- c("Route", selCols)

  ## Last-minute name changes just for printing
  fares$Date <- format(fares$Day,  "%a %b %d")
  selCols <- gsub("Day", "Date", selCols)
  ## selCols <- c("Score",selCols)
  fares$Match <- paste(round(100 * fares$Score/max(fares$Score), 0), "%")
  selCols <- c("Match",selCols)  
  
  return(fares[ord,selCols])
})

output$rankTable <- DT::renderDataTable(outDat(),
                                        rownames=FALSE, # only TRUE for testing
                                        escape=FALSE,  # for allowing HTML to be rendered
                                        ## extensions=c("Scroller", "ColReorder", "ColVis"),
                                        extensions=c("Scroller"),
                                        options = list(
                                          columnDefs = list(list(className = "dt-center",
                                            targets = 0:(ncol(outDat())-1)),
                                            list(orderable = FALSE,
                                                 targets = 0:(ncol(outDat())-1))),
                                          deferRender = TRUE,
                                          ## dom = 'C<"clear">frtSR',
                                          dom = 'tS',
                                          scrollY = "600px",
                                          scrollCollapse = TRUE))

