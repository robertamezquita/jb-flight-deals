##' Scoring for Desired Calendar Dates
##'
##' Takes as input maximum number of stops and outputs a \code{vector} of scores
##' corresponding to the input \code{data.frame} of flights (\code{Fares}),
##' ranked such that flights with less than the number of stop(s) are highly scored,
##' and those that are not receive decreasing/zero scores.
##'
##' For these dates, type must be \code{Date} (use \code{as.Date} function)
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
##' out = as.Date("2/29/2016", format = "%m/%d/%Y")
##' outend = as.Date("2/30/2016", format = "%m/%d/%Y")
##' CalendarScore(out, flights = dat$Fares)
##' CalendarScore(out, outend, flights = dat$Fares)
##' CalendarScore(out, outend, flights = dat$Fares, nearbyOutbound = TRUE, nearby = 5)

CalendarScore <- function(dateOutboundStart, dateOutboundEnd = NULL,
                          dateInboundStart = NULL, dateInboundEnd = NULL,
                          nearbyOutbound = FALSE, nearbyInbound = NULL, nearby = 3,
                          flights) {

    ## Input is not used
    if (is.na(dateOutboundStart)) {
        return(rep(0, nrow(flights)))
    }

    ## Case: Nearby flag is false
    if (nearbyOutbound == FALSE) {
        ## Subcase: Simple match - end not specified 
        if (is.null(dateOutboundEnd)) {
            rank <- (flights$Day == dateOutboundStart) %>% as.numeric
        } else {
        ## Subcase: Interval - end specified, but not nearby
            start <- (flights$Day - dateOutboundStart) >= 0
            end <- (flights$Day - dateOutboundEnd) <= 0
            rank <- (start + end) == 2 %>% as.numeric
        }
    } else {
    ## Case: Nearby flag is set
        ## Subcase: Start only + nearby
        if (is.null(dateOutboundEnd)) {
            dateOutboundEnd <- dateOutboundStart + nearby
        } else {
        ## Subcase: End is specified
            dateOutboundEnd <- dateOutboundEnd + nearby
        }
        dateOutboundStart <- dateOutboundStart - nearby ## mod Out start after previous block
        start <- (flights$Day - dateOutboundStart) >= 0
        end <- (flights$Day - dateOutboundEnd) <= 0
        rank <- (start + end) == 2 %>% as.numeric
    }

    ## Success??
    return(rank)
}
        
