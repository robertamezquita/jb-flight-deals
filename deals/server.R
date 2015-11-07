## Server.R for deals
fares <- dat$Fares

## Create Naive Ranking
ord <- 1:nrow(fares)

## Display fares

outDat <- reactive({

  selCols <- c("Day", "Time", "Origin", "Destination")

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

