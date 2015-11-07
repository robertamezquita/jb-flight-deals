##' DestScore
##' Calculate a numeric score for each flight based on dest
##'
##' @param dest The dest of the User (closest airport)
##' @param flights a n x m Data Frame containing Fare information
##' @param airportRegions a Data Frame containing mappings between airports and geographic regions
##' @param nearby a Flag for whether dests nearby should be searched. If TRUE, other airports in the same geographic area are given weights between 0 and 1.
##' @param nearbyWeight how much to weight nearby airport codes (only used if nearby is TRUE)
##' @import dplyr
##' @return scores a vector of scores (length n) in [0, 1] with higher values indicating more preferable dests of flights in flights

DestScore <- function(dest, flights, airportRegions, nearby=FALSE, nearbyWeight=0.75) {
  if(is.null(dest)) {
    return(rep(0, nrow(flights)))
  }

  ## 1 for exact match to dest
  scores <- ifelse(flights$Destination == dest, 1, 0)

  ## Give partial score for dests in same geographic region (nearby)
  if(nearby) {
    geo <- dplyr::filter(airportRegions, AirportCode == dest) %>%
      select(GeographicRegionId)
    codes <- dplyr::filter(airportRegions, GeographicRegionId == as.numeric(geo)) %>%
      select(AirportCode)
    codes <- setdiff(codes, dest)    
    scores <- scores + ifelse(flights$Destination %in% as.character(codes$AirportCode),
                              nearbyWeight, 0)
  }
  return(scores)
}
