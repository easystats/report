#' Omega Squared Interpretation
#'
#' @param omega_squared Value or vector of omega squared values.
#' @param rules Can be "field2013" (default) or custom set of rules.
#'
#'
#'
#' @examples
#' interpret_omega_squared(.02)
#' interpret_omega_squared(c(.5, .02))
#' @seealso http://imaging.mrc-cbu.cam.ac.uk/statswiki/FAQ/effectSize
#'
#'
#' @references
#' \itemize{
#'   \item{Field, A (2013) Discovering statistics using IBM SPSS Statistics. Fourth Edition. Sage:London.}
#' }
#' @export
interpret_omega_squared <- function(omega_squared, rules = "field2013") {
  if (is.rules(rules)) {
    return(interpret(omega_squared, rules))
  } else {
    if (rules == "field2013") {
      return(interpret(omega_squared, rules(c(0.01, 0.06, 0.14), c("very small", "small", "medium", "large"))))
    } else {
      stop("rules must be 'field2013' or an object of type rules.")
    }
  }
}
