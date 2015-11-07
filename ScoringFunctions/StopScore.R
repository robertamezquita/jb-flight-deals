##' Scoring for Number of Stops
##'
##' Takes as input maximum number of stops and outputs a \code{vector} of scores
##' corresponding to the input \code{data.frame} of flights (\code{Fares}),
##' ranked such that flights with less than the number of stop(s) are highly scored,
##' and those that are not receive decreasing/zero scores.
##'
##' @param stops vector of one market as a \code{MarketGroupId}
##'          (corresponding to 1 = California, 2 = Caribbean, etc. - see dat$MarketGroup)
##' @param flights \code{data.frame} of flights with \code{FareType}, \code{DollarFare},
##'          \code{DollarTax}, \code{PointsFare}, \code{PointsTax}
##' 
##' @return \code{vector} of values corresponding to ranking of flights
##'         returns vector of 0 if input is NA
##' 
##' @import dplyr
##' 
##' @examples
##' StopScore(0, dat$Fare) ## only works for Nonstop flights (0)

StopScore <- function(stops, flights) {
    ## Input is not used
    if (is.na(stops)) {
        return(rep(0, nrow(flights)))
    }

    ## Filter based on =< number of stops
    if (stops == 0) {
        rank <- flights$FlightType == "NONSTOP" %>% as.numeric
    }

    ## Success?
    return(rank)
}
