##' Scoring for MarketGroup
##'
##' Takes as input desired market group(s) and outputs a \code{vector} of scores
##' corresponding to the input \code{data.frame} of flights (\code{Fares}),
##' ranked such that flights with destinations to selected market group(s) are highly scored,
##' and those that are not receive decreasing/zero scores.
##'
##' For when a user inputs multiple markets, this function is run multiple times, and outside
##' of the function, the scores are weighted by coefficients based on the desired markets
##' being ordered (ranked) or unordered (unranked). 
##'
##' @param markets vector of one market as a \code{MarketGroupId}
##'          (corresponding to 1 = California, 2 = Caribbean, etc. - see dat$MarketGroup)
##' @param flights \code{data.frame} of flights with \code{FareType}, \code{DollarFare},
##'          \code{DollarTax}, \code{PointsFare}, \code{PointsTax}
##' @param marketTable table describing the relationship between \code{AirportCode},
##'          \code{GeographicRegionId}, \code{MarketGroupId}, and \code{GeographicRegionName}
##'
##' @return \code{vector} of values corresponding to ranking of flights
##'         returns vector of 0 if input is NA
##' 
##' @import dplyr
##' 
##' @examples
##' MarketScore(1, dat$Fare, dat$MarketTable)

MarketScore <- function(market, flights, marketTable) {
    ## Input is not used
    if (is.na(market)) {
        return(rep(0, nrow(flights)))
    }

    ## Filter eligible airports based on preferred market
    eligible <- dplyr::filter(marketTable, MarketGroupId %in% market)

    ## Score flights based on defined markets above
    rank <- flights$Destination %in% eligible$AirportCode %>% as.numeric

    ## Success?
    return(rank)
}
