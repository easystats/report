#' p-values Interpretation
#'
#' @param p Value or vector of p-values.
#' @param rules Can be "default" or custom set of rules.
#'
#'
#'
#' @examples
#' interpret_p(.02)
#' interpret_p(c(.5, .02))
#' @export
interpret_p <- function(p, rules = "default") {
  if (is.rules(rules)) {
    return(interpret(p, rules))
  } else {
    if (rules == "default") {
      return(interpret(p, rules(c(0.05), c("significant", "not significant"))))
    } else {
      stop("rules must be 'default' or an object of type rules.")
    }
  }
}
