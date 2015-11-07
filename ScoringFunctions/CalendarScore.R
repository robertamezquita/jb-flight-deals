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
##'          or the first availability of a range [not used]
##' @param dateInboundEnd calendar date for end of availability for desired inbound flight [not used]
##' @param nearbyOutbound include nearby dates for outbound flights
##' @param nearbyInbound include nearby dates for inbound flights [not used]
##' @param nearby parameter for max days to include as nearby [default: 3]
##' @param flights \code{data.frame} of flights with \code{Day}
##' 
##' @return \code{vector} of values corresponding to ranking of flights
##'         returns vector of 0 if input is NA
##' 
##' @import dplyr
##' 
##' @examples
##' CalendarScore("2/29/2016", flights = dat$Fares)
##' CalendarScore("2/29/2016", "3/1/2016", flights = dat$Fares)

CalendarScore <- function(dateOutboundStart, dateOutboundEnd = NULL,
                          dateInboundStart = NULL, dateInboundEnd = NULL,
                          nearbyOutbound = NULL, nearbyInbound = NULL, nearby = 3,
                          flights) {

    ## Input is not used
    if (is.na(dateOutboundStart)) {
        return(rep(0, nrow(flights)))
    }

    ## Case: Only single day specified
    if (is.null(dateOutboundEnd)) {
        
    
    ## Success?
    return(rank)
}
