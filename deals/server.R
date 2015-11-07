## Server.R for deals
dataDir <- "data"
files <- dir(dataDir, full.names=TRUE)
names(files) <- basename(files)
names(files) <- gsub(".csv", "", names(files))
names(files) <- gsub("-stg", "", names(files), fixed=TRUE)
names(files) <- gsub("-", "_", names(files), fixed=TRUE)
names(files) <- gsub(".Fare", "", names(files), fixed=TRUE)

## Read in the data!
dat <- lapply(files, read.csv)

## EXPLORE
lapply(dat, head)
fares <- dat$Fares

## Create Naive Ranking
ord <- 1:nrow(fares)

## Display fares
f <- filter(fares, FareType == input$FareType)
selCols <- c("FlightDate", "Origin", "Destination", "Price")

outDat <- reactive({


  input$FareType <- "LOWEST"

})

outDat <- f[ord,]

output$rankTable <- DT::renderDataTable(outDat(),
                                        rownames=TRUE, # only for testing
                                        extensions=c("Scroller", "ColReorder", "ColVis"),
                                        options = list(
                                          columnDefs = list(list(orderable = FALSE,
                                            targets = 0:(ncol(f)-1))),
                                          deferRender = TRUE,
                                          dom = 'C<"clear">frtSR',
                                          scrollY = "600px",
                                          scrollCollapse = TRUE))

