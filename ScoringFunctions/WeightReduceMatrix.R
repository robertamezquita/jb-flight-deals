##' Weight and Reduce a Matrix by Preference Strength
##'
##' Documentation on documentation. Should be passed a matrix consisting of columns as vectors from
##' scoring functions and a \code{preferenceStrength} number which defines how much weight to give
##' rank-ordered variables (0 = weight all equally, 1 = weight top ranked variables heavily).
##'

WeightReduceMatrix <- function(mat, preferenceStrength = 0) {
    ## Function to determine preferenceStrength
    ## Adds a uniform + exponential together
    p <- preferenceStrength
    len <- seq(0, 1, by = 0.01)
    ex <- p * dexp(len, rate = 3)
    un <- (1 - p) * dunif(len)
    dist <- apply(cbind(ex, un), 1, mean)
    ## plot(len, dist, ylim = c(0, 1.5), main = p)

    ## Draw from unif + exp function based on number of columns in matrix
    q <- matrix(quantile(dist,
                         seq(0, 1, length.out = ncol(mat) + 2))[2:(ncol(mat) + 1)],
                nrow = 1)
    q <- q[ncol(q):1]                   # reverse the column order

    ## Multiple by vec
    vec <- t(q %*% t(mat))
    vec <- vec/max(vec)                 # return as fraction of largest

    ## Success??
    return(vec)
}
