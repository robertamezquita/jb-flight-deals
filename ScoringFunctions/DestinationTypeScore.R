##' Scoring for DestinationType
##'
##' Takes as input desired destination type(s) and outputs a \code{vector} of scores
##' corresponding to the input \code{data.frame} of flights (\code{Fares}),
##' ranked such that flights with destinations to selected destination type(s) are highly scored,
##' and those that are not receive decreasing/zero scores.
##'
##' For when a user inputs multiple markets, this function is run multiple times, and outside
##' of the function, the scores are weighted by coefficients based on the desired destination types
##' being ordered (ranked) or unordered (unranked). 
##'
##' @param destinationType vector of one destination type as a string of \code{DestinationTypeName}
##'          (corresponding to 19 = Family, 21 = Nightlife, 22 = Exploration, 23 = Romance, 24 = Beach)
##' @param flights \code{data.frame} of flights with \code{FareType}, \code{DollarFare},
##'          \code{DollarTax}, \code{PointsFare}, \code{PointsTax}
##' @param cityPairDestinationType table describing the relationship between \code{DestinationTypeId},
##'          and \code{DestinationAirportCode}
##' @param destinationTypeTable table describing the relationship between the strings \code{DestinationTypeId}
##'
##' @return \code{vector} of values corresponding to ranking of flights
##'         returns vector of 0 if input is NA
##' 
##' @import dplyr
##' 
##' @examples
##' DestinationTypeScore("Family", dat$Fare, dat$CityPairDestinationType, dat$DestinationType)


DestinationTypeScore <- function(destinationType, flights, cityPairDestinationType, destinationTypeTable) {
    ## Input is not used
    if (is.null(destinationType)) {
        return(rep(0, nrow(flights)))
    }
    
    ## Map destinationType character strings to Id's
    id <- destinationTypeTable[destinationType == destinationTypeTable$DestinationTypeName,
                               "DestinationTypeId"]
    
    ## Filter eligible airports based on preferred market
    eligible <- dplyr::filter(cityPairDestinationType, DestinationTypeId %in% id)
    
    ## Score flights based on defined markets above
    rank <- flights$Destination %in% eligible$DestinationAirportCode %>% as.numeric
    
    ## Success?
    return(rank)
}

    
