#' Effective Sample Size (ESS) Interpretation
#'
#' @param effective_sample Value or vector of effective sample (ESS) values.
#' @param rules Can be "burkner2017" (default) or custom set of \code{\link{rules}}.
#'
#'
#' @examples
#' interpret_effective_sample(1001)
#' interpret_effective_sample(c(852, 1200))
#' @references
#' \itemize{
#'   \item Bürkner, P. C. (2017). brms: An R package for Bayesian multilevel models using Stan. Journal of Statistical Software, 80(1), 1-28.
#' }
#' @export
interpret_effective_sample <- function(effective_sample, rules = "burkner2017") {
  if (is.rules(rules)) {
    return(interpret(abs(effective_sample), rules))
  } else {
    if (rules == "burkner2017") {
      return(interpret(abs(effective_sample), rules(c(1000), c("unsufficient", "sufficient"))))
    } else {
      stop("rules must be 'burkner2017' or an object of type rules.")
    }
  }
}
