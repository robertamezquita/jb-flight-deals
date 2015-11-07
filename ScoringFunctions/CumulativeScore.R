##' Cumulative Score
##'
##' Combines all the different scoring functions into one super function.
##'
##' scoreMatrix <- matrix(rnorm(30), 10, 3) ## n x f matrix, f = factors
##' coef <- matrix(c(a = .5, b = .6, c = .7), 1, 3) ## row vector

CumulativeScore <- function(scoreMatrix, coef = matrix(rep(1, ncol(scoreMatrix)), nrow = 1)) {
    ## Multiply coefficients by scoreMatrix to get score
    finalscore <- coef %*% t(scoreMatrix)

    ## Success??
    return(finalscore)
}

