##' Scoring for Budget
##'
##' Takes as input points or fares and outputs a \code{vector} of scores
##' corresponding to the input \code{data.frame} of flights (\code{Fares}),
##' ranked such that flights below the given budget threshold are highly scored,
##' and those above receive decreasing scores as the budget threshold is exceeded.
##'
##' @param budget numeric describing threshold for budget
##' @param flights \code{data.frame} of flights with \code{FareType}, \code{DollarFare},
##'        \code{DollarTax}, \code{PointsFare}, \code{PointsTax} 
##' @param type dollars or points describing budget type
##'
##' @return vector of values corresponding to ranking of flights
##'         returns vector of 0 if input is NA
##' 
##' @import dplyr
##' 
##' @examples
##' BudgetScore(300, dat$Fares)
##' BudgetScore(30000, dat$Fares, type = "points")
##' ## returns vector of rankings corr. to each flight in dat$Fares

BudgetScore <- function(budget, flights, type = "dollars") {
    ## Input is not used
    if (is.na(budget)) {
        return(rep(0, nrow(flights)))
    }
    
    ## Calculate cost (base + tax)
    if (type == "dollars") {
        cost <- flights$DollarFare + flights$DollarTax
    } else {
        cost <- flights$PointsFare + flights$PointsTax
    }

    ## Ranking Function
    ## Provides 1 and 0 vals for now, but can be
    ## made to give range based on threshold vs. not
    ## TODO: weight more heavily the flights that are below budget
    ##   and decrease weight the further away from budget it is
    rank <- as.numeric(cost < budget)

    ## Success?
    return(rank)
}
