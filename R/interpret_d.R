#' Standardized Difference (Cohen's d) Interpretation
#'
#' @param d Value or vector of d values.
#' @param rules Can be "cohen1988" (default), "sawilowsky2009" or custom set of rules.
#'
#' 
#'
#' @examples
#' interpret_d(.02)
#' interpret_d(c(.5, .02))
#' @references
#' \itemize{
#'   \item Cohen, J. (1988). Statistical power analysis for the behavioural sciences.
#'   \item Sawilowsky, S. S. (2009). New effect size rules of thumb.
#' }
#' @export
interpret_d <- function(d, rules = "cohen1988") {
  if (is.rules(rules)) {
    return(interpret(abs(d), rules))
  } else {
    if (rules == "cohen1988") {
      return(interpret(abs(d), rules(c(0.2, 0.5, 0.8), c("very small", "small", "medium", "large"))))
    } else if (rules == "sawilowsky2009") {
      return(interpret(abs(d), rules(c(0.1, 0.2, 0.5, 0.8, 1.2, 2), c("tiny", "very small", "small", "medium", "large", "very large", "huge"))))
    } else {
      stop("rules must be 'cohen1988', 'sawilowsky2009' or an object of type rules.")
    }
  }
}
