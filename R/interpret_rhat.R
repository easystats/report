#' Rhat Interpretation
#'
#' @param rhat Value or vector of Rhat values.
#' @param rules Can be "vehtari2019" (default), "gelman1992" or custom set of rules.
#'
#'
#' @examples
#' interpret_rhat(1.00)
#' interpret_rhat(c(1.5, 0.9))
#' @references
#' \itemize{
#'   \item Gelman, A., & Rubin, D. B. (1992). Inference from iterative simulation using multiple sequences. Statistical science, 7(4), 457-472.
#'   \item Vehtari, A., Gelman, A., Simpson, D., Carpenter, B., & Bürkner, P. C. (2019). Rank-normalization, folding, and localization: An improved Rhat for assessing convergence of MCMC. arXiv preprint arXiv:1903.08008.
#' }
#' @export
interpret_rhat <- function(rhat, rules = "vehtari2019") {
  if (is.rules(rules)) {
    return(interpret(abs(rhat), rules))
  } else {
    if (rules == "vehtari2019") {
      return(interpret(abs(rhat), rules(c(1.01), c("converged", "failed"))))
    } else if (rules == "gelman1992") {
      return(interpret(abs(rhat), rules(c(1.1), c("converged", "failed"))))
    } else {
      stop("rules must be 'vehtari2019', 'gelman1992' or an object of type rules.")
    }
  }
}
