## Server.R for deals
fares <- dat$Fares

## Display fares

outDat <- reactive({

  selCols <- c("Day", "Time", "Origin", "Destination")

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
  ord <- 1:nrow(fares)

  ## Handle what columns to show depending on whether price should be
  ## shown as dollars, points, or both
  if(is.null(input$faretype)) {
    return(NULL)
  }
  if ("points" %in% input$faretype) {
    fares$Points <- fares$PointsFare + fares$PointsTax
    selCols <- c("Points", selCols)
  }
  if("dollars" %in% input$faretype) {
    fares$Dollars <- fares$DollarFare + fares$DollarTax
    selCols <- c("Dollars", selCols)
  }

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

