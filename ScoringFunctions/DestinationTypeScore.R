##' Scoring for DestinationType
##'
##' Takes as input desired destination type(s) and outputs a \code{vector} of scores
##' corresponding to the input \code{data.frame} of flights (\code{Fares}),
##' ranked such that flights with destinations to selected destination type(s) are highly scored,
##' and those that are not receive decreasing/zero scores.
##'
##' ## For when a user inputs multiple types, this function is run multiple times, and outside
##' of the function, the scores are weighted by coefficients based on the desired destination types
##' being ordered (ranked) or unordered (unranked). 
##'
##' @param types vector of one or more destination type(s) as a string of \code{DestinationTypeName}
##'          (corresponding to 19 = Family, 21 = Nightlife, 22 = Exploration, 23 = Romance, 24 = Beach)
##' @param flights \code{data.frame} of flights with \code{FareType}, \code{DollarFare},
##'          \code{DollarTax}, \code{PointsFare}, \code{PointsTax}
##' @param destinationTypeTable table describing the relationship between \code{DestinationAirportCode},
##'          \code{DestinationTypeId}, and \code{DestinationTypeName}
##' @param preferenceStrength value that weights ordered \code{to} field according to priority, such that
##'        larger values of \code{preferenceStrength} more heavily weight top-ranked choices
##'
##' @return \code{vector} of values corresponding to ranking of flights
##'         returns vector of 0 if input is NA
##' 
##' @import dplyr
##' 
##' @examples
##' DestinationTypeScore("Family", dat$Fare, dat$TypeTable)


DestinationTypeScore <- function(types, flights, destinationTypeTable, preferenceStrength = 0) {
    ## Input is not used
    if (is.null(types)) {
        return(rep(0, nrow(flights)))
    }

    ## Iterate for each type that is included
    rankList <- list()
    for (i in 1:length(types)) {
        ## Map destinationType character strings to Id's
        eligible <- dplyr::filter(destinationTypeTable, DestinationTypeName == types[i])
    
        ## Filter eligible airports based on preferred market
        rankList[[i]] <- flights$Destination %in% eligible$DestinationAirportCode %>% as.numeric
    }

    ## Case: if only one types is provided; return solo vector
    if (length(rankList) == 1) {
        return(rankList[[1]])
    }

    ## Else: continue with weighting and reducing into ranked vector output
    mat <- Reduce(cbind, rankList)
    rank <- WeightReduceMatrix(mat, preferenceStrength)

    ## Success?
    return(rank)
}
