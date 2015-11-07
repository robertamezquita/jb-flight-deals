##' Scoring for Desired Calendar Dates
##'
##' Takes as input maximum number of stops and outputs a \code{vector} of scores
##' corresponding to the input \code{data.frame} of flights (\code{Fares}),
##' ranked such that flights with less than the number of stop(s) are highly scored,
##' and those that are not receive decreasing/zero scores.
##'
##' @param dateOutboundStart calendar date for desired outbound flight,
##'          or the first availability of a range
##' @param dateOutboundEnd calendar date for end of availability for desired outbound flight
##' @param dateInboundStart calendar date for desired inbound flight, 
##'          or the first availability of a range
##' @param dateInboundEnd calendar date for end of availability for desired inbound flight
##' @param nearbyOutbound include nearby dates for outbound flights
##' @param nearbyInbound include nearby dates for inbound flights
##' @param nearby parameter for max days to include as nearby [default: 3]
##' @param flights \code{data.frame} of flights with \code{Day}
##' 
##' @return \code{vector} of values corresponding to ranking of flights
##'         returns vector of 0 if input is NA
##' 
##' @import dplyr
##' 
##' @examples
##' CalendarScore("2/29/2016", flights = dat$Fare)
##' CalendarScore("2/29/2016", "3/1/2016", flights = dat$Fare)

CalendarScore <- function(dateOutboundStart, dateOutboundEnd = NULL,
                          dateInboundStart, dateInboundEnd = NULL,
                          nearbyOutbound = NULL, nearbyInbound = NULL, nearby = 3,
                          flights) {

    ## Input is not used
    if (is.na(dateOutboundStart)) {
        return(rep(0, nrow(flights)))
    }

    ## Filter based on =< number of stops
    as.Date(flights$FlightDate)

    ## Success?
    return(rank)
}
