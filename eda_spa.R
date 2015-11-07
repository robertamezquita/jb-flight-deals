###################################################################################
## Do the HACK                                                                   ##
###################################################################################

#######################
## Load in libraries ##
#######################
library(dplyr)

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
input <- list()
input$FareType <- "LOWEST"

## Display fares
f <- filter(fares, FareType == input$FareType)
show(head(f[ord,]))


