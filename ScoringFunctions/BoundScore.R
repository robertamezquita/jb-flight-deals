##' Scoring and Ranking of "TO" or "FROM" Input Fields
##'
##' Blah. Tired of documenting. Takes the vector of inputs from the "TO" or "FROM" field in the app
##' and then processes them to output a (weighted?) score matrix.
##'
##' @param bound vector of values corresponding to \code{AirportCode}, \code{GeographicRegionName},
##'        \code{MarketGroupName} such that are out or in bound
##' @param flights data regarding available flights
##' @param marketTable table describing the relationship between \code{AirportCode},
##'          \code{GeographicRegionId}, \code{MarketGroupId}, and \code{GeographicRegionName},
##'          and \code{MarketGroupName}
##' @param preferenceStrength value that weights ordered \code{to} field according to priority, such that
##'        larger values of \code{preferenceStrength} more heavily weight top-ranked choices
##'
##' @examples
##' BoundScore(c("BDL", "Northeast", "Desert/Mountain"), dat$Fares, dat$MarketTable, 0)
