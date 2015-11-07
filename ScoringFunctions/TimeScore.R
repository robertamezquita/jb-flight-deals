##' Scoring for Desired Calendar Dates
##'
##' Takes as input maximum number of stops and outputs a \code{vector} of scores
##' corresponding to the input \code{data.frame} of flights (\code{Fares}),
##' ranked such that flights with less than the number of stop(s) are highly scored,
##' and those that are not receive decreasing/zero scores.
##'
##' @param timeOutboundStart time for desired outbound flight, or the first availability of a range
##' @param timeOutboundEnd last availability of a range for outbound flight
##' @param timeInboundStart time for desired inbound flight, or the first availability of a range
##' @param timeInboundEnd last availability of a range for inbound flight
##' @param flights \code{data.frame} of flights with \code{Time}
##' 
##' @return \code{vector} of values corresponding to ranking of flights
##'         returns vector of 0 if input is NA
##' 
##' @import dplyr
##' 
##' @examples
##' TimeScore("14:00", flights = dat$Fare)
##' TimeScore("14:00", "16:00", flights = dat$Fare)

TimeScore <- function(timeOutboundStart = NULL, timeOutBoundEnd = NULL,
                      timeOutboundType = NULL, timeInboundType = NULL,
                      flights) {

    ## Input is not used
    if (is.na(timeOutboundStart)) {
        return(rep(0, nrow(flights)))
    }

    ## Filter based on =< number of stops
    ## as.Date(flights$FlightDate)

    ## ## Success?
    ## return(rank)
}
