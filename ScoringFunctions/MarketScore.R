##' Scoring for MarketGroup
##'
##' Takes as input desired market group and outputs a \code{vector} of scores
##' corresponding to the input \code{data.frame} of flights (\code{Fares}),
##' ranked such that flights with destinations to selected market group(s) are highly scored,
##' and those that are not receive decreasing/zero scores.
##'
##' For when a user inputs multiple markets, this function is run multiple times, and outside
##' of the function, the scores are weighted by coefficients based on the desired markets
##' being ordered (ranked) or unordered (unranked). 
##'
##' @param market vector of one market as a \code{MarketGroupName}
##'          (corresponding to 1 = California, 2 = Caribbean, etc. - see dat$MarketGroup)
##' @param type one of "Destination" or "Origin"
##' @param flights \code{data.frame} of flights with \code{FareType}, \code{DollarFare},
##'          \code{DollarTax}, \code{PointsFare}, \code{PointsTax}
##' @param marketTable table describing the relationship between \code{AirportCode},
##'          \code{GeographicRegionId}, \code{MarketGroupId}, and \code{GeographicRegionName},
##'          and \code{MarketGroupName}
##'
##' @return \code{vector} of values corresponding to ranking of flights
##'         returns vector of 0 if input is NA
##' 
##' @import dplyr
##' 
##' @examples
##' MarketScore(1, dat$Fare, dat$MarketTable)

MarketScore <- function(market, type=c("Origin", "Destination"), flights, marketTable) {
    ## Input is not used
    if (is.null(market)) {
        return(rep(0, nrow(flights)))
    }

    type <- match.arg(type)
    
    ## Filter eligible airports based on preferred market
    eligible <- dplyr::filter(marketTable, MarketGroupName %in% market)

    ## Score flights based on defined markets above
    rank <- flights[[type]] %in% eligible$AirportCode %>% as.numeric

    ## Success?
    return(rank)
}
