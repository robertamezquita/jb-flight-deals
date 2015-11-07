##' Data Parser
##'
##' Reads in dataset
##' Munges together the AirportRegion and DestinationType tables into one

library(dplyr) ## comment later
library(tidyr) ## comment later

dataDir <- "data"
files <- dir(dataDir, full.names=TRUE)
names(files) <- basename(files)
names(files) <- gsub(".csv", "", names(files))
names(files) <- gsub("-stg", "", names(files), fixed=TRUE)
names(files) <- gsub("-", "_", names(files), fixed=TRUE)
names(files) <- gsub(".Fare", "", names(files), fixed=TRUE)

## Read in the data!
dat <- lapply(files, read.csv)

## Create Market
dat$MarketTable <- dplyr::full_join(dat$AirportRegion, dat$GeographicRegion, by = "GeographicRegionId")

## Tidy Date
dat$Fare <- tidyr::separate(dat$Fares, FlightDate, c("Day", "Time"), sep = " ") %>% head


