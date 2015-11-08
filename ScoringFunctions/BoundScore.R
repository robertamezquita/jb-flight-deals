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
##' @param type "Origin" or "Destination" character string
##' @param nearby flag for whether to group with nearby flights
##' @param preferenceStrength value that weights ordered \code{to} field according to priority, such that
##'        larger values of \code{preferenceStrength} more heavily weight top-ranked choices
##'
##' @examples
##' BoundScore(c("BDL", "Northeast", "Desert/Mountain"), dat$Fares, "ORIGIN",
##'            nearby = TRUE, dat$MarketTable, preferenceStrength = 0)


BoundScore <- function(bound, flights, type, nearby, marketTable, preferenceStrength = 0) {
    ## Check if null
    if(is.null(bound)) {
        return(rep(0, nrow(flights)))
    }
    
    ## Iterate across input bound
    rankList <- list()
    for (i in 1:length(bound)) {
        ## Determine the type that is being considered
      id <- data.frame(t(apply(marketTable[, c("AirportCode", "GeographicRegionName",
                                             "MarketGroupName")], 2, function(x) {
            bound[i] %in% x
        })))

      ## print(head(id))
      
        ## Switch: AirportCode
        if (id["AirportCode"] == TRUE) {
            rankList[[i]] <- AirportScore(bound[i], type, flights, marketTable, nearby)
            next
        }
        ## Case: GeographicRegion
        if (id["GeographicRegionName"] == TRUE) {
            rankList[[i]] <- GeographicScore(bound[i], flights, marketTable)
            next
        }
        ## Case: MarketGroup
        if (id["MarketGroupName"] == TRUE) {
            rankList[[i]] <- MarketScore(bound[i], flights, marketTable)
            next
        }
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
