##' AirportScore
##'
##' Calculate a numeric score for each flight based on airport
##'
##' @param airport The airport code as a string (e.g. "JFK")
##' @param type one of "Destination" or "Origin"
##' @param flights a n x m Data Frame containing Fare information
##' @param airportRegions a Data Frame containing mappings between airports and geographic regions
##' @param nearby a Flag for whether dests nearby should be searched. If TRUE, other airports in the same geographic area are given weights between 0 and 1.
##' @param nearbyWeight how much to weight nearby airport codes (only used if nearby is TRUE)
##' @import dplyr
##' @return scores a vector of scores (length n) in [0, 1] with higher values indicating higher preference
AirportScore <- function(airport, type=c("Origin", "Destination"),
                         flights, airportRegions,
                         nearby=FALSE, nearbyWeight=0.75) {
  if(is.null(airport)) {
    return(rep(0, nrow(flights)))
  }

  type <- match.arg(type)

  ## 1 for exact match to airport
  scores <- ifelse(flights[[type]] == airport, 1, 0)

  ## Give partial score for airports in same geographic region (nearby)
  if(nearby) {
    geo <- dplyr::filter(airportRegions, AirportCode == airport) %>%
      select(GeographicRegionId)
    codeDat <- dplyr::filter(airportRegions, GeographicRegionId == as.numeric(geo)) %>%
      select(AirportCode)
    codes <- setdiff(codeDat$AirportCode, airport)    
    scores <- scores + ifelse(flights[[type]] %in% as.character(codes),
                              nearbyWeight, 0)
  }
  return(scores)
}
