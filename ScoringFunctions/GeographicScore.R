##' Scoring for Geographic Region
##'
##' Takes as input desired geographic region and outputs a \code{vector} of scores
##' corresponding to the input \code{data.frame} of flights (\code{Fares}),
##' ranked such that flights with destinations to selected geographic region is highly scored,
##' and those that are not receive decreasing/zero scores.
##'
##' For when a user inputs multiple markets, this function is run multiple times, and outside
##' of the function, the scores are weighted by coefficients based on the desired markets
##' being ordered (ranked) or unordered (unranked). 
##'
##' @param geographic string of one geographic region as a \code{GeographicRegionName}
##'          (corresponding to 1 = SF Bay, 2 = LA Area, etc. - see dat$GeographicRegion)
##' @param flights \code{data.frame} of flights with \code{FareType}, \code{DollarFare},
##'          \code{DollarTax}, \code{PointsFare}, \code{PointsTax}
##' @param marketTable table describing the relationship between \code{GeographicRegionId},
##'          \code{MarketGroupId}, \code{GeographicRegionName}, and \code{AirportCode} -
##'          see \code{dat$MarketTable}
##'
##' @return \code{vector} of values corresponding to ranking of flights
##'         returns vector of 0 if input is NA
##' 
##' @import dplyr
##' 
##' @examples
##' Geographic("Desert West", dat$Fares, dat$MarketTable)

GeographicScore <- function(geographic, flights, marketTable) {
    ## Input is not used
    if (is.null(geographic)) {
        return(rep(0, nrow(flights)))
    }

    ## Filter eligible airports based on preferred market
    eligible <- dplyr::filter(marketTable, GeographicRegionName %in% geographic)

    ## Score flights based on defined markets above
    rank <- flights$Destination %in% eligible$AirportCode %>% as.numeric

    ## Success?
    return(rank)
}
