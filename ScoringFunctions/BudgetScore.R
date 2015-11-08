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
    if (is.null(budget)) {
        return(rep(0, nrow(flights)))
    }
    
    ## Calculate cost (base + tax)
    if (type == "dollars") {
        cost <- flights$DollarFare + flights$DollarTax
    } else {
        cost <- flights$PointsFare + flights$PointsTax
    }

    ## Ranking Function
    ## Transforms into a logistic function
    ## with rescaling s.t. values are mapped from 0 -> 1
    diff <- budget - cost
    diff.t <- diff ## transform placeholder
    diff.t[diff < 0] <- rescale(-1 * log(-1 * diff[diff < 0]), c(0, .5))
    diff.t[diff >= 0] <- rescale(log(diff[diff >= 0]), c(0.5, 1))
    rank <- diff.t ## as.numeric(cost < budget)

    ## Diagnostic Plots of Transform
    ## plot(diff[diff < 0], diff.t[diff < 0])
    ## plot(diff[diff >= 0], diff.t[diff >= 0])
    
    ## Success?
    return(rank)
}
