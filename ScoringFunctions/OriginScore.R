##' OriginScore
##' Calculate a numeric score for each flight based on origin
##'
##' @param origin The origin of the User (closest airport)
##' @param flights a n x m Data Frame containing Fare information
##' @param airportRegions a Data Frame containing mappings between airports and geographic regions
##' @param nearby a Flag for whether origins nearby should be searched. If TRUE, other airports in the same geographic area are given weights between 0 and 1.
##' @import dplyr
##' @return scores a vector of scores (length n) in [0, 1] with higher values indicating more preferable origins of flights in flights

OriginScore <- function(origin, flights, airportRegions, nearby=FALSE) {
  if(is.null(origin)) {
    return(rep(0, nrow(flights)))
  }
  ## 1 for exact match to origin
  scores <- ifelse(flights$Origin == origin, 1, 0)

  ## Give partial score for origins in same geographic region (nearby)
  if(nearby) {
    geo <- dplyr::filter(airportRegions, AirportCode == origin) %>%
      select(GeographicRegionId)
    codes <- dplyr::filter(airportRegions, GeographicRegionId == as.numeric(geo)) %>%
      select(AirportCode)
    scores <- scores + ifelse(flights$Origin %in% as.character(codes$AirportCode), 0.75, 0)
  }
  return(scores)
}

