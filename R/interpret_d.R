#' Standardized Difference (Cohen's d) Interpretation
#'
#' @param d Value or vector of d values.
#' @param rules Can be "cohen1988" (default), "sawilowsky2009" or custom set of rules.
#'
#' @author \href{https://dominiquemakowski.github.io/}{Dominique Makowski}
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
  if (rules == "cohen1988") {
    return(interpret(d, rules(c(0.2, 0.5, 0.8), c("very small", "small", "medium", "large"))))
  } else if (rules == "sawilowsky2009") {
    return(interpret(d, rules(c(0.1, 0.2, 0.5, 0.8, 1.2, 2), c("tiny", "very small", "small", "medium", "large", "very large", "huge"))))
  } else if (!is.rules(rules)) {
    stop("The rules set must be an object of type rules.")
  } else {
    return(interpret(d, rules))
  }
}
